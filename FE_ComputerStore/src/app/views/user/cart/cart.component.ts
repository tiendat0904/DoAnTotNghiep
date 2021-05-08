import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { Toast, ToastrService } from 'ngx-toastr';
import { timeout } from 'rxjs/operators';
import { accountModel } from '../../../models/account-model';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { ItemModel } from '../../../models/item-model';
import { productModel } from '../../../models/product-model';
import { voucherModel } from '../../../models/voucher-model';
import { AccountService } from '../../../services/account/account.service';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { ProductService } from '../../../services/product/product.service';
import { VoucherService } from '../../../services/voucher/voucher.service';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit {

  list_item: Array<ItemModel> = [];
  list_product: Array<billDetailModel> = [];
  list_bill: Array<billModel> = [];
  update_bill_id: any;
  list_product_filter: Array<billDetailModel> = [];
  list_bill_detail: Array<billDetailModel> = [];
  list_bill_filter: Array<billModel> = [];
  list_voucher: Array<billModel> = [];
  total = 0;
  billDetailModel: billDetailModel;
  itemModel: ItemModel;
  account: accountModel;
  voucherModel: voucherModel;
  bill_id: any;
  bill_detail_id: any;
  billModel: any;
  account_id: any;
  voucher:any;
  submitted = false;
  formGroup: FormGroup;
  update_customer_name: any;
  update_email: any;
  update_phone_number: any;
  update_address: any;
  selectedType: any;
  constructor(private cartService: CartService,
    private fb: FormBuilder,
    private productService: ProductService,
    private billService: BillService,
    private billDetailService: BillDetailService,
    private accountService: AccountService,
    private router: Router,
    private toastr: ToastrService,
    private voucherService:VoucherService) { }

  ngOnInit(): void {
    this.submitted = true;
    this.selectedType = 0;
    this.loadListProductCart();
    this.formGroup = new FormGroup({
      customer_name: new FormControl(),
      email: new FormControl(),
      phone_number: new FormControl(),
      address: new FormControl()
    });
  }


  selectcontinue() {
    this.router.navigate(['/']);
  }

  loadListProductCart() {
    this.list_product = [];
    this.list_bill = [];
    this.update_bill_id = localStorage.getItem("bill_id");
    // this.list_product.length = 0;
    // this.account_id = 0;
    let account_id = 0;
    account_id = Number(localStorage.getItem("account_id"));
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        this.list_bill_filter = this.list_bill.filter(function (laptop) {
          return (laptop.customer_id === account_id && laptop.order_status_id === 1);
        });
        if (this.list_bill_filter.length !== 0) {
          this.billDetailService.getAll().subscribe(data => {
            this.list_product_filter = data.data;
            this.list_product = this.list_product_filter.filter(product => product.bill_id === this.list_bill_filter[0].bill_id);
            localStorage.setItem("listProduct", JSON.stringify(this.list_product));
            this.bill_detail_id = this.list_product[0].bill_detail_id;
          })
          // for (let item of this.list_bill_filter){
          //   this.billDetailModel = {
          //     product_id: item.product_id,
          //     price: item.product.price_new,
          //     image: item.product.image,
          //     amount: item.quantity,
          //     product_name: item.product.product_name,
          //   }   
          //   this.list_product.push(this.billDetailModel);
          // }
        } else {
          this.list_product = [];
        }
        // else{
        //   this.billDetailService.getAll().subscribe(data => {
        //     this.list_product_filter = data.data;
        //     this.list_product = this.list_product_filter.filter(product => product.bill_id === this.update_bill_id)
        //   },
        //   err => {
        //     })
        // }
      })
      this.accountService.getInfo().subscribe(data => {
        this.update_customer_name = data.data.full_name;
        this.update_email = data.data.email;
        this.update_phone_number = data.data.phone_number;
        this.update_address = data.data.address;
        this.formGroup = this.fb.group({
          customer_name: [this.update_customer_name],
          email: [this.update_email],
          phone_number: [this.update_phone_number],
          address: [this.update_address],
        });
      })

    } else {
      this.list_item = this.cartService.getItems();
      // this.list_product.length = this.list_item.length;
      if (this.list_item !== null) {
        let checkprice: boolean;
        let pricecheck: any;
        for (let item of this.list_item) {
          if (item.product.price_new === null) {
            pricecheck = item.product.price;
          } else {
            pricecheck = item.product.price_new;
          }
          this.billDetailModel = {
            product_id: item.product.product_id,
            price: pricecheck,
            image: item.product.image,
            warranty: item.product.warranty,
            amount: item.quantity,
            product_name: item.product.product_name,
          }
          this.list_product.push(this.billDetailModel);
        }
      }
    }
    setTimeout(() => this.totalCart(), 1000);
  }


  orderSuccess() {
    console.log(this.selectedType);
    this.submitted = false;
    this.list_bill = [];
    this.list_bill_filter = [];
    let account: accountModel;
    let bill: billModel;
    let account_id = Number(localStorage.getItem("account_id"));
    if (localStorage.getItem("account_id")) {
      account = {
        email: this.formGroup.get('email')?.value,
        full_name: this.formGroup.get('customer_name')?.value,
        phone_number: this.formGroup.get('phone_number')?.value,
        address: this.formGroup.get('address')?.value,
      }
      this.accountService.update(account).subscribe(data => {
        this.billService.getAll().subscribe(data => {
          this.list_bill = data.data;
          this.list_bill_filter = this.list_bill.filter(function (laptop) {
            return (laptop.customer_id === account_id && laptop.order_status_id === 1);
          });
          if (this.list_bill_filter.length === 0) {
            this.toastr.warning("Giỏ hàng trống, vui lòng thêm sản phẩm vào giỏ hàng");
          }
          else {
            if (this.selectedType === 0) {
              this.toastr.warning("Vui lòng chọn hình thức thanh toán");
            } else {
              bill = {
                order_status_id: 2,
                order_type_id: this.selectedType
              }
              this.billService.update(this.list_bill_filter[0].bill_id, bill).subscribe(data => {
                this.cartService.clearCart();
                this.toastr.success("Đặt hàng thành công");
                this.router.navigate(['/send-cart']);
              })
            }

          }
        })
      })

    } else {
      this.toastr.warning("Vui lòng đăng nhập trước khi đặt hàng !!")
    }
  }

  usevoucher(){
    if(localStorage.getItem("account_id")){
      this.voucherService.detail(localStorage.getItem("account_id")).subscribe(data=>{
        
        if(data.data !== undefined){
          this.list_voucher = data.data;
        }
      })
    }
    
  }

  totalCart() {
    this.total = 0;
    let account_id = 0;
    account_id = Number(localStorage.getItem("account_id"));
    this.account_id = localStorage.getItem("account_id");
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        this.list_bill_filter = this.list_bill.filter(function (laptop) {
          return (laptop.customer_id === account_id && laptop.order_status_id === 1);
        });
        if (this.list_bill_filter.length !== 0) {
          this.billDetailService.getAll().subscribe(data => {
            this.list_product_filter = data.data;
            this.list_product = this.list_product_filter.filter(product => product.bill_id === this.list_bill_filter[0].bill_id)
            if (this.list_product !== null) {
              for (let i of this.list_product) {
                this.total += i.amount * i.price;
              }
              localStorage.setItem("total", this.total.toString());
            }
            else {
            }
          },
            err => {
            })
        }
      })
    }
    else {
      this.total = 0;
      this.list_item = this.cartService.getItems();
      if (this.list_product !== null) {
        for (let i of this.list_product) {
          this.total += i.amount * i.price;
        }
      }
      else {
        this.total = 0;
      }
    }
  }

  deletecart() {
    let account_id = 0;
    account_id = Number(localStorage.getItem("account_id"));
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        this.list_bill_filter = this.list_bill.filter(function (laptop) {
          return (laptop.customer_id === account_id && laptop.order_status_id === 1);
        });
        const modelDelete = {
          id: this.list_bill_filter[0].bill_id
        };
        this.billService.delete(modelDelete).subscribe(data => {
          data.data.success;
        });
        this.cartService.clearCart();
        this.totalCart();
      })

    } else {
      this.cartService.clearCart();
      this.totalCart();
    }
    this.loadListProductCart();
  }

  
  deleteItem(item) {
    this.list_bill_detail = [];
    if (localStorage.getItem("account_id")) {
      let list_bill_detail_filter = this.list_bill_detail;
      this.billDetailService.getAll().subscribe(data => {
        this.list_bill_detail = data.data;
        list_bill_detail_filter = this.list_bill_detail.filter(bill_detail => bill_detail.product_id === item);
        if (list_bill_detail_filter.length !== 0) {
          const modelDelete = {
            id: list_bill_detail_filter[0].bill_detail_id
          };
          this.billDetailService.delete(modelDelete).subscribe(data => {
          })
          this.cartService.deleteItem(item);
          this.totalCart();
        }
      })

    }
    else {
      this.cartService.deleteItem(item);
      this.loadListProductCart();
    }

  }

  addQuantity(item) {
    this.list_bill = [];
    this.list_bill_detail = [];
    let bill_detail_id;
    let account = Number(localStorage.getItem("account_id"));
    let list_bill_filter = this.list_bill;
    let list_bill_detail_filter = this.list_bill_detail;
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        list_bill_filter = this.list_bill.filter(bill => bill.customer_id === account);
        this.billDetailService.getAll().subscribe(data => {
          this.list_bill_detail = data.data;
          list_bill_detail_filter = this.list_bill_detail.filter(function (bill_detail) {
            return (bill_detail.bill_id === list_bill_filter[0].bill_id && bill_detail.product_id === item);
          });
          bill_detail_id = list_bill_detail_filter[0].bill_detail_id;
          this.billDetailModel = {
            amount: list_bill_detail_filter[0].amount + 1
          }
          this.billDetailService.update(list_bill_detail_filter[0].bill_detail_id, this.billDetailModel).subscribe(data => {
            this.totalCart();
          })

        })
      })
    }
    else {
      this.cartService.addQty(item);
      this.loadListProductCart();
    }

  }

  minusQuantity(item) {
    this.list_bill = [];
    this.list_bill_detail = [];
    let bill_detail_id;
    let account = Number(localStorage.getItem("account_id"));
    let list_bill_filter = this.list_bill;
    let list_bill_detail_filter = this.list_bill_detail;
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        list_bill_filter = this.list_bill.filter(bill => bill.customer_id === account);
        this.billDetailService.getAll().subscribe(data => {
          this.list_bill_detail = data.data;
          list_bill_detail_filter = this.list_bill_detail.filter(function (bill_detail) {
            return (bill_detail.bill_id === list_bill_filter[0].bill_id && bill_detail.product_id === item);
          });
          bill_detail_id = list_bill_detail_filter[0].bill_detail_id;
          this.billDetailModel = {
            amount: list_bill_detail_filter[0].amount - 1
          }
          this.billDetailService.update(list_bill_detail_filter[0].bill_detail_id, this.billDetailModel).subscribe(data => {
            this.totalCart();
          })

        })
      })
    }
    else {
      this.cartService.minusQty(item);
      this.loadListProductCart();
    }
  }
}
