import { Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../loader/loader.service';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { ItemModel } from '../../../models/item-model';
import { BuildPCModel } from '../../../models/pc-model';
import { productModel } from '../../../models/product-model';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { PcService } from '../../../services/pc/pc.service';
import { ProductService } from '../../../services/product/product.service';
import { SelectItemBuildPcComponent } from './select-item-build-pc/select-item-build-pc.component';
declare var $: any;

@Component({
  selector: 'app-build-pc',
  templateUrl: './build-pc.component.html',
  styleUrls: ['./build-pc.component.scss']
})
export class BuildPcComponent implements OnInit {

  @ViewChild(SelectItemBuildPcComponent) view!: SelectItemBuildPcComponent;
  product_cpu: BuildPCModel;
  product_main: BuildPCModel;
  product_ram: BuildPCModel;
  product_hdd: BuildPCModel;
  product_ssd: BuildPCModel;
  product_vga: BuildPCModel;
  product_psu: BuildPCModel;
  product_case: BuildPCModel;
  product_manhinh: BuildPCModel;
  product_keyboard: BuildPCModel;
  product_mouse: BuildPCModel;
  product_headphone: BuildPCModel;
  product_loa: BuildPCModel;
  product_ghe: BuildPCModel;
  product_fancase: BuildPCModel;
  product_tannhiet: BuildPCModel;
  checkCPU = false;
  checkDisplayCPU = true;
  checkmain = false;
  checkDisplayMain = true;
  checkram = false;
  checkDisplayRAM = true;
  checkhdd = false;
  checkDisplayHDD = true;
  checkssd = false;
  checkDisplaySSD = true;
  checkvga = false;
  checkDisplayVGA = true;
  checkpsu = false;
  checkDisplayPSU = true;
  checkcase = false;
  checkDisplayCase = true;
  checkmanhinh = false;
  checkDisplayManHinh = true;
  checkkeyboard = false;
  checkDisplayKeyboard = true;
  checkmouse = false;
  checkDisplayMouse = true;
  checkheadphone = false;
  checkDisplayHeadphone = true;
  checkloa = false;
  checkDisplayloa = true;
  checkghe = false;
  checkDisplayGhe = true;
  checkfancase = false;
  checkDisplayFanCase = true;
  checktannhiet = false;
  checkDisplayTanNhiet = true;
  array_build_pc: Array<BuildPCModel> = [];
  array_build_pc_minus: Array<BuildPCModel> = [];
  array_build_pc_minus_filter: Array<BuildPCModel> = [];
  array_build_pc_add: Array<BuildPCModel> = [];
  array_build_pc_add_filter: Array<BuildPCModel> = [];
  array_bill: Array<billModel> = [];
  array_bill_filter: Array<billModel> = [];
  array_pc = [];
  billDetailModel: billDetailModel;
  billModel: billModel;
  total = 0;
  total_money = 0;
  itemModel: ItemModel;
  buildPCModel: BuildPCModel;
  modalReference: any;
  closeResult: string;


  constructor(
    private pcService: PcService,
    private cartService: CartService,
    private toastr: ToastrService, private modalService: NgbModal,
    private productService: ProductService,
    private router: Router,
    private billService: BillService,
    private billDetailService: BillDetailService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.resetCheckBuildPC();
    this.loadproduct();
    
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
    });
    this.modalReference.result.then(
      (result: any) => {
        this.closeResult = `Closed with: ${result}`;
      },
      (reason: any) => {
        this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
      }
    );
  }

  private getDismissReason(reason: any): string {
    if (reason === ModalDismissReasons.ESC) {
      return 'by pressing ESC';
    } else if (reason === ModalDismissReasons.BACKDROP_CLICK) {
      return 'by clicking on a backdrop';
    } else {
      return `with: ${reason}`;
    }
  }

  initModal(product_type: any, type: any): void {
    this.view.view(product_type, type);
  }

  addToCart() {
    if (localStorage.getItem("account_id")) {
      if (this.array_build_pc.length !== 0) {
        this.billService.getByAccount(localStorage.getItem("account_id")).subscribe(data => {
          if (data.data !== []) {
            this.array_bill = data.data;
            this.array_bill_filter = this.array_bill.filter(bill => bill.order_status_id === 1);
            if (this.array_bill_filter.length === 0) {
              this.billModel = {
                customer_id: Number(localStorage.getItem("account_id")),
              }
              this.billService.create(this.billModel).subscribe(data => {
                for (let item of this.array_build_pc) {
                  this.billDetailModel = {
                    bill_id: data.data[0].bill_id,
                    product_id: item.product_id,
                    price: item.price,
                    amount: item.quantity,
                  }
                  this.billDetailService.create(this.billDetailModel).subscribe(data => {
                  });
                }
              });
            } else {
              for (let item of this.array_build_pc) {
                this.billDetailModel = {
                  bill_id: this.array_bill_filter[0].bill_id,
                  product_id: item.product_id,
                  price: item.price,
                  amount: item.quantity,
                }
                this.billDetailService.create(this.billDetailModel).subscribe(data => {
                })
              }
            }
          }

        })
        this.toastr.success("Thêm vào giỏ hàng thành công", 'www.tiendatcomputer.vn cho biết');
        this.router.navigate(['cart']);
      } else {
        this.toastr.warning("Bộ PC đang trống, vui lòng thêm linh kiện !!!", 'www.tiendatcomputer.vn cho biết');
      }
    } else {
      if (this.array_pc.length !== 0) {
        for (let item of this.array_pc) {
          this.cartService.addToCartByPC(item);
        }
        this.toastr.success("Thêm vào giỏ hàng thành công", 'www.tiendatcomputer.vn cho biết');
        this.router.navigate(['cart']);
      } else {
        this.toastr.warning("Bộ PC đang trống, vui lòng thêm linh kiện !!!", 'www.tiendatcomputer.vn cho biết');
      }
    }
  }


  totalPC() {
    if (localStorage.getItem("account_id")) {
      this.total = 0;
      this.pcService.detail(localStorage.getItem("account_id")).subscribe(data => {
        this.array_build_pc = data.data;
        if (this.array_build_pc !== []) {
          for (let item of this.array_build_pc) {
            this.total += item.price * item.quantity;
          }
          this.total_money = this.total;
        } else {
          this.total_money = 0;
        }
      })
    } else {
      this.total = 0;
      this.array_pc = this.pcService.getItems();
      if (this.array_pc !== null) {
        for (let i of this.array_pc) {
          this.total += i.quantity * i.product.price_display;
        }
        this.total_money = this.total;
      }
      else {
        this.total_money = 0;
      }
    }
  }

  addQuantity(item) {
    if (localStorage.getItem("account_id")) {
      this.pcService.detail(localStorage.getItem("account_id")).subscribe(data => {
        this.array_build_pc_minus = data.data;
        this.array_build_pc_minus_filter = this.array_build_pc_minus.filter(pc => pc.product_id === item)
        if (this.array_build_pc_minus_filter[0].quantity <= 10) {
          this.buildPCModel = {
            build_pc_id: this.array_build_pc_minus_filter[0].build_pc_id,
            quantity: this.array_build_pc_minus_filter[0].quantity + 1
          }
          this.pcService.update(this.array_build_pc_minus_filter[0].build_pc_id, this.buildPCModel).subscribe(data => {
            this.loadproduct();
          });
        }
      })
    } else {
      this.pcService.addQty(item);
      this.loadproduct();
    }
  }

  deleteItem(item) {
    let array_build_delete = [];
    if (localStorage.getItem("account_id")) {
      this.pcService.detail(localStorage.getItem("account_id")).subscribe(data => {
        this.array_build_pc = data.data;
        array_build_delete = this.array_build_pc.filter(pc =>
          (pc.customer_id === Number(localStorage.getItem("account_id")) && pc.product_id === item));
        const modelDelete = {
          id: array_build_delete[0].build_pc_id
        };
        this.pcService.delete(modelDelete).subscribe(data => {
          this.resetCheckBuildPC();
          this.loadproduct();
          this.modalReference.dismiss();
        });
      })
    } else {
      this.pcService.deleteItem(item);
      this.resetCheckBuildPC();
      this.loadproduct();
      this.modalReference.dismiss();
    }
  }

  minusQuantity(item) {
    if (localStorage.getItem("account_id")) {
      this.pcService.detail(localStorage.getItem("account_id")).subscribe(data => {
        this.array_build_pc_minus = data.data;
        this.array_build_pc_minus_filter = this.array_build_pc_minus.filter(pc => pc.product_id === item)
        if (this.array_build_pc_minus_filter[0].quantity > 1) {
          this.buildPCModel = {
            build_pc_id: this.array_build_pc_minus_filter[0].build_pc_id,
            quantity: this.array_build_pc_minus_filter[0].quantity - 1
          }
          this.pcService.update(this.array_build_pc_minus_filter[0].build_pc_id, this.buildPCModel).subscribe(data => {
            this.loadproduct();
          });
        }
      })
    } else {
      this.pcService.minusQty(item);
      this.loadproduct();
    }
  }

  resetBuildPC() {
    let build_pc_delete = [];
    if (localStorage.getItem("account_id")) {
      this.pcService.detail(localStorage.getItem("account_id")).subscribe(data => {
        this.array_build_pc = data.data;
        for (let item of this.array_build_pc) {
          build_pc_delete.push(item.build_pc_id);
        }
        const modelDelete = {
          listId: build_pc_delete
        };
        this.pcService.delete(modelDelete).subscribe(data => {
          this.toastr.success("Làm mới cấu hình PC thành công.", 'www.tiendatcomputer.vn cho biết');

          this.resetCheckBuildPC();
          this.loadproduct();
        });
      })
    } else {
      this.pcService.clearCart();

      this.loadproduct();
      this.resetCheckBuildPC();
    }
    this.modalReference.dismiss();
  }

  resetCheckBuildPC() {
    this.checkCPU = false;
    this.checkDisplayCPU = true;
    this.checkmain = false;
    this.checkDisplayMain = true;
    this.checkram = false;
    this.checkDisplayRAM = true;
    this.checkhdd = false;
    this.checkDisplayHDD = true;
    this.checkssd = false;
    this.checkDisplaySSD = true;
    this.checkvga = false;
    this.checkDisplayVGA = true;
    this.checkpsu = false;
    this.checkDisplayPSU = true;
    this.checkcase = false;
    this.checkDisplayCase = true;
    this.checkmanhinh = false;
    this.checkDisplayManHinh = true;
    this.checkkeyboard = false;
    this.checkDisplayKeyboard = true;
    this.checkmouse = false;
    this.checkDisplayMouse = true;
    this.checkheadphone = false;
    this.checkDisplayHeadphone = true;
    this.checkloa = false;
    this.checkDisplayloa = true;
    this.checkghe = false;
    this.checkDisplayGhe = true;
    this.checkfancase = false;
    this.checkDisplayFanCase = true;
    this.checktannhiet = false;
    this.checkDisplayTanNhiet = true;
  }

  loadproduct() {
    this.array_build_pc = [];
    if (localStorage.getItem("account_id")) {
      this.pcService.detail(localStorage.getItem("account_id")).subscribe(data => {
        if (data.data !== [])
          this.array_build_pc = data.data;
        if (this.array_build_pc !== []) {
          for (let item of this.array_build_pc) {
            switch (item.product_type_name) {
              case "CPU":
                this.checkCPU = true;
                this.checkDisplayCPU = false;
                this.product_cpu = item;
                break;
              case "Main":
                this.checkmain = true;
                this.checkDisplayMain = false;
                this.product_main = item;
                break;
              case "RAM":
                this.checkram = true;
                this.checkDisplayRAM = false;
                this.product_ram = item;
                break;
              case "HDD":
                this.checkhdd = true;
                this.checkDisplayHDD = false;
                this.product_hdd = item;
                break;
              case "SSD":
                this.checkssd = true;
                this.checkDisplaySSD = false;
                this.product_ssd = item;
                break;
              case "VGA":
                this.checkvga = true;
                this.checkDisplayVGA = false;
                this.product_vga = item;
                break;
              case "PSU":
                this.checkpsu = true;
                this.checkDisplayPSU = false;
                this.product_psu = item;
                break;
              case "CASE":
                this.checkcase = true;
                this.checkDisplayCase = false;
                this.product_case = item;
                break;
              case "Màn hình":
                this.checkmanhinh = true;
                this.checkDisplayManHinh = false;
                this.product_manhinh = item;
                break;
              case "Keyboard":
                this.checkkeyboard = true;
                this.checkDisplayKeyboard = false;
                this.product_keyboard = item;
                break;
              case "Mouse":
                this.checkmouse = true;
                this.checkDisplayMouse = false;
                this.product_mouse = item;
                break;
              case "Headphone":
                this.checkheadphone = true;
                this.checkDisplayHeadphone = false;
                this.product_headphone = item;
                break;
              case "Loa":
                this.checkloa = true;
                this.checkDisplayloa = false;
                this.product_loa = item;
                break;
              case "Ghế gaming":
                this.checkghe = true;
                this.checkDisplayGhe = false;
                this.product_ghe = item;
                break;
              case "Fan Case":
                this.checkfancase = true;
                this.checkDisplayFanCase = false;
                this.product_fancase = item;
                break;
              case "Tản nhiệt nước":
                this.checktannhiet = true;
                this.checkDisplayTanNhiet = false;
                this.product_tannhiet = item;
                break;
              default:
                break;
            }
          }
        }
      })
    } else {
      let pricecheck: any;
      this.array_pc = this.pcService.getItems();
      if (this.array_pc !== [] && this.array_pc !== null) {
        for (let item of this.array_pc) {
          if (item.product.price_new === null) {
            pricecheck = item.product.price;
          } else {
            pricecheck = item.product.price_new;
          }
          this.buildPCModel = {
            product_id: item.product.product_id,
            product_name: item.product.product_name,
            image: item.product.image,
            price: pricecheck,
            warranty: item.product.warranty,
            quantity: item.quantity,
            product_type_name: item.product.product_type_name
          }
          this.array_build_pc.push(this.buildPCModel);
        }
        // }
      }
      if (this.array_build_pc !== []) {
        for (let item of this.array_build_pc) {
          switch (item.product_type_name) {
            case "CPU":
              this.checkCPU = true;
              this.checkDisplayCPU = false;
              this.product_cpu = item;
              break;
            case "Main":
              this.checkmain = true;
              this.checkDisplayMain = false;
              this.product_main = item;
              break;
            case "RAM":
              this.checkram = true;
              this.checkDisplayRAM = false;
              this.product_ram = item;
              break;
            case "HDD":
              this.checkhdd = true;
              this.checkDisplayHDD = false;
              this.product_hdd = item;
              break;
            case "SSD":
              this.checkssd = true;
              this.checkDisplaySSD = false;
              this.product_ssd = item;
              break;
            case "VGA":
              this.checkvga = true;
              this.checkDisplayVGA = false;
              this.product_vga = item;
              break;
            case "PSU":
              this.checkpsu = true;
              this.checkDisplayPSU = false;
              this.product_psu = item;
              break;
            case "CASE":
              this.checkcase = true;
              this.checkDisplayCase = false;
              this.product_case = item;
              break;
            case "Màn hình":
              this.checkmanhinh = true;
              this.checkDisplayManHinh = false;
              this.product_manhinh = item;
              break;
            case "Keyboard":
              this.checkkeyboard = true;
              this.checkDisplayKeyboard = false;
              this.product_keyboard = item;
              break;
            case "Mouse":
              this.checkmouse = true;
              this.checkDisplayMouse = false;
              this.product_mouse = item;
              break;
            case "Headphone":
              this.checkheadphone = true;
              this.checkDisplayHeadphone = false;
              this.product_headphone = item;
              break;
            case "Loa":
              this.checkloa = true;
              this.checkDisplayloa = false;
              this.product_loa = item;
              break;
            case "Ghế gaming":
              this.checkghe = true;
              this.checkDisplayGhe = false;
              this.product_ghe = item;
              break;
            case "Fan Case":
              this.checkfancase = true;
              this.checkDisplayFanCase = false;
              this.product_fancase = item;
              break;
            case "Tản nhiệt nước":
              this.checktannhiet = true;
              this.checkDisplayTanNhiet = false;
              this.product_tannhiet = item;
              break;
            default:
              break;
          }
        }
      }
    }
    this.totalPC();
  }
}
