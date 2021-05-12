import { Component, EventEmitter, OnInit, Output, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'angular-bootstrap-md';
import { ToastrService } from 'ngx-toastr';
import { ItemModel } from '../../../../models/item-model';
import { productModel } from '../../../../models/product-model';
import { trademarkModel } from '../../../../models/trademark-model';
import { PcService } from '../../../../services/pc/pc.service';
import { ProductService } from '../../../../services/product/product.service';
import { TrademarkService } from '../../../../services/trademark/trademark.service';

@Component({
  selector: 'app-select-item-build-pc',
  templateUrl: './select-item-build-pc.component.html',
  styleUrls: ['./select-item-build-pc.component.scss']
})
export class SelectItemBuildPcComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  modalReference!: any;
  arraylist_product: Array<productModel> = [];
  arraylist_product_filter: Array<productModel> = [];
  arraylist_product_include: Array<productModel> = [];
  arraylist_trademark: Array<trademarkModel> = [];
  arraylist_trademark_selected: Array<trademarkModel> = [];
  arraylist_trademark_filter: Array<trademarkModel> = [];
  closeResult: string;
  array_pc = [];
  searchedKeyword: string;
  check_product: boolean;
  items: ItemModel;
  product_type: any;
  constructor(private modalService: NgbModal,
    private toastr: ToastrService,
    private productService: ProductService,
    private trademarkService: TrademarkService,
    private pcService: PcService) { }

  ngOnInit(): void {
    this.check_product = true;
  }

  add(product: productModel) {
    this.array_pc = this.pcService.getItems();
    console.log(this.product_type);
    if (this.pcService.getItems() && this.array_pc.length !==0) {
      for (let item of this.array_pc) {
        if (item.product.product_type_name === this.product_type) {
          switch (item.product.product_type_name) {
            case "CPU":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Main":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "RAM":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "HDD":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "SSD":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "VGA":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "PSU":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "CASE":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Màn hình":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Keyboard":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Mouse":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Headphone":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Loa":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Ghế gaming":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Fan Case":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            case "Tản nhiệt nước":
              this.pcService.deleteItem(item.product.product_id);
              this.pcService.addToCart(product);
              this.eventEmit.emit('success');
              this.modalReference.dismiss();
              break;
            default:
              break;
          }
          break;
        } else {
          this.pcService.addToCart(product);
          this.eventEmit.emit('success');
          this.modalReference.dismiss();
           break;
        }
      }
    } else {
      this.pcService.addToCart(product);
      this.eventEmit.emit('success');
      this.modalReference.dismiss();
     
    }

  }


  view(product_type: any) {
    this.product_type = product_type;
    this.arraylist_product_filter = [];
    this.arraylist_trademark_filter = [];
    this.arraylist_trademark_selected = [];
    this.open(this.childModal);
    this.productService.getAll().subscribe(data => {
      this.arraylist_product = data.data;
      this.arraylist_product_include = this.arraylist_product_filter = this.arraylist_product.filter(function (laptop) {
        return (laptop.product_type_name === product_type);
      });
      this.trademarkService.getAll().subscribe(data => {
        this.arraylist_trademark = data.data;
        for (let item1 of this.arraylist_trademark) {
          for (let item2 of this.arraylist_product_filter) {
            if (item2.amount === 0) {
              item2.check = "Liên hệ";
              item2.checkAmount = false;
            }
            else {
              item2.check = "Còn hàng";
              item2.checkAmount = true;
            }
            if (item2.price_new === null) {
              // item2.isCheckPrice = true;
              item2.price_display = item2.price;
            } else {
              // item2.isCheckPrice = false;
              item2.price_display = item2.price_new;
            }
            if (item1.trademark_id === item2.trademark_id) {
              this.arraylist_trademark_selected.push(item1);
            }
          }

        }
        this.arraylist_trademark_filter = this.arraylist_trademark_selected.filter((test, index, array) =>
          index === array.findIndex((findTest) =>
            findTest.trademark_name === test.trademark_name
          ));
      })
    });
  }


  public filterByKeyword() {
    for (let item of this.arraylist_trademark_filter) {
      item.selected = false;
    }
    var filterResult = [];
    this.arraylist_product_filter = this.arraylist_product_include;
    if (this.searchedKeyword === null || this.searchedKeyword.length === 0) {
      this.arraylist_product_filter = this.arraylist_product_include;
    } else {
      this.arraylist_product_filter = this.arraylist_product_filter;
      var keyword = this.searchedKeyword.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
      this.arraylist_product_filter.forEach(item => {
        var product_name = item.product_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
        var product_type_name = item.product_type_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
        if (product_name.includes(keyword) || product_type_name.includes(keyword)) {
          filterResult.push(item);
        }
      });
      if (filterResult.length === 0) {
        this.check_product = false;
        this.arraylist_product_filter = null;
      } else {
        this.check_product = true;
        this.arraylist_product_filter = filterResult;
      }
    }

  }

  public filterProducts(): void {
    this.check_product = true;
    this.searchedKeyword = null;
    this.arraylist_product_filter = this.arraylist_product_include;
    let list_product_filter = this.arraylist_product_filter;
    const activeColors = this.arraylist_trademark_filter.filter(c => c.selected).map(c => c.trademark_id);

    if (activeColors.length === 0) {
      this.arraylist_product_filter = this.arraylist_product_include;

    } else {
      let list = list_product_filter.filter(product => activeColors.includes(product.trademark_id));
      this.arraylist_product_filter = [];
      this.arraylist_product_filter = list;

    }
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
      centered: true,
      size: <any>'xl',
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


}
