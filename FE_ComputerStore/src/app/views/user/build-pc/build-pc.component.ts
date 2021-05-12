import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { productModel } from '../../../models/product-model';
import { CartService } from '../../../services/cart/cart.service';
import { PcService } from '../../../services/pc/pc.service';
import { SelectItemBuildPcComponent } from './select-item-build-pc/select-item-build-pc.component';

@Component({
  selector: 'app-build-pc',
  templateUrl: './build-pc.component.html',
  styleUrls: ['./build-pc.component.scss']
})
export class BuildPcComponent implements OnInit {

  @ViewChild(SelectItemBuildPcComponent) view!: SelectItemBuildPcComponent;
  product_cpu: productModel;
  product_main: productModel;
  product_ram: productModel;
  product_hdd: productModel;
  product_ssd: productModel;
  product_vga: productModel;
  product_psu: productModel;
  product_case: productModel;
  product_manhinh: productModel;
  product_keyboard: productModel;
  product_mouse: productModel;
  product_headphone: productModel;
  product_loa: productModel;
  product_ghe: productModel;
  product_fancase: productModel;
  product_tannhiet: productModel;
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
  array_pc = [];
  total = 0;
  total_money = 0;
  modalReference: any;
  closeResult: string;


  constructor(private pcService: PcService, private cartService: CartService, private toastr: ToastrService,private modalService: NgbModal,) { }

  ngOnInit(): void {
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


  initModal(product_type: any): void {
    this.view.view(product_type);
  }

  addToCart() {
    if(this.array_pc.length !==0){
      for (let item of this.array_pc) {
        this.cartService.addToCartByPC(item);
      }
      this.toastr.success("Thêm vào giỏ hàng thành công");
    }else{
      this.toastr.warning("Bộ PC đang trống, vui lòng thêm linh kiện !!!");
    }
    
  }


  totalPC() {
    this.total = 0;
    // let account_id = 0;
    // account_id = Number(localStorage.getItem("account_id"));
    // this.account_id = localStorage.getItem("account_id");
    // if (localStorage.getItem("account_id")) {
    //   this.billService.getAll().subscribe(data => {
    //     this.list_bill = data.data;
    //     this.list_bill_filter = this.list_bill.filter(function (laptop) {
    //       return (laptop.customer_id === account_id && laptop.order_status_id === 1);
    //     });
    //     if (this.list_bill_filter.length !== 0) {
    //       this.billDetailService.getAll().subscribe(data => {
    //         this.list_product_filter = data.data;
    //         this.list_product = this.list_product_filter.filter(product => product.bill_id === this.list_bill_filter[0].bill_id)
    //         if (this.list_product !== null) {
    //           for (let i of this.list_product) {
    //             this.total += i.amount * i.price; 
    //           }
    //           this.total_money = this.total;
    //           localStorage.setItem("total_money",this.total_money.toString());
    //         }
    //         else {
    //         }
    //       },
    //         err => {
    //         })
    //     }
    //   })
    // }
    // else {
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
    // }
  }

  addQuantity(item) {
    // this.list_bill = [];
    // this.list_bill_detail = [];
    // let bill_detail_id;
    // let account = Number(localStorage.getItem("account_id"));
    // let list_bill_filter = this.list_bill;
    // let list_bill_detail_filter = this.list_bill_detail;

    this.pcService.addQty(item);
    this.loadproduct();
    // this.loadListProductCart();


  }

  deletePC() {
    // let account_id = 0;
    // account_id = Number(localStorage.getItem("account_id"));
    // if (localStorage.getItem("account_id")) {
    //   this.billService.getAll().subscribe(data => {
    //     this.list_bill = data.data;
    //     this.list_bill_filter = this.list_bill.filter(function (laptop) {
    //       return (laptop.customer_id === account_id && laptop.order_status_id === 1);
    //     });
    //     const modelDelete = {
    //       id: this.list_bill_filter[0].bill_id
    //     };
    //     this.billService.delete(modelDelete).subscribe(data => {
    //       data.data.success;
    //     });
    //     this.cartService.clearCart();
    //     this.totalPC();
    //   })

    // } else {
    this.pcService.clearCart();
    // this.totalPC();
    // }
    this.loadproduct();
  }


  deleteItem(item) {
    // this.list_bill_detail = [];
    // if (localStorage.getItem("account_id")) {
    //   let list_bill_detail_filter = this.list_bill_detail;
    //   this.billDetailService.getAll().subscribe(data => {
    //     this.list_bill_detail = data.data;
    //     list_bill_detail_filter = this.list_bill_detail.filter(bill_detail => bill_detail.product_id === item);
    //     if (list_bill_detail_filter.length !== 0) {
    //       const modelDelete = {
    //         id: list_bill_detail_filter[0].bill_detail_id
    //       };
    //       this.billDetailService.delete(modelDelete).subscribe(data => {
    //       })
    //       this.cartService.deleteItem(item);
    //       this.totalPC();
    //     }
    //   })

    // }
    // else {
    this.pcService.deleteItem(item);
    this.loadproduct();
    // }

  }

  minusQuantity(item) {
    // this.list_bill = [];
    // this.list_bill_detail = [];
    // let bill_detail_id;
    // let account = Number(localStorage.getItem("account_id"));
    // let list_bill_filter = this.list_bill;
    // let list_bill_detail_filter = this.list_bill_detail;
    // if (localStorage.getItem("account_id")) {
    //   this.billService.getAll().subscribe(data => {
    //     this.list_bill = data.data;
    //     list_bill_filter = this.list_bill.filter(bill => bill.customer_id === account);
    //     this.billDetailService.getAll().subscribe(data => {
    //       this.list_bill_detail = data.data;
    //       list_bill_detail_filter = this.list_bill_detail.filter(function (bill_detail) {
    //         return (bill_detail.bill_id === list_bill_filter[0].bill_id && bill_detail.product_id === item);
    //       });
    //       bill_detail_id = list_bill_detail_filter[0].bill_detail_id;
    //       this.billDetailModel = {
    //         amount: list_bill_detail_filter[0].amount - 1
    //       }
    //       this.billDetailService.update(list_bill_detail_filter[0].bill_detail_id, this.billDetailModel).subscribe(data => {
    //         this.totalPC();
    //       })

    //     })
    //   })
    // }
    // else {
    this.pcService.minusQty(item);
    this.loadproduct();
    // }
  }

  resetBuilPC() {
    this.pcService.clearCart();
    this.loadproduct();
    this.modalReference.dismiss();
  }

  loadproduct() {
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
    this.array_pc = this.pcService.getItems();
    if (this.pcService.getItems()) {
      for (let item of this.array_pc) {
        switch (item.product.product_type_name) {
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
    this.totalPC();
  }



}
