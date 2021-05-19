import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
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
import * as htmlToImage from 'html-to-image';
import { MailService } from '../../../services/mail/mail.service';
import { mailModel } from '../../../models/mail-model';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit {

  list_item: Array<ItemModel> = [];
  list_product: Array<billDetailModel> = [];
  list_bill: Array<billModel> = [];
  list_voucher: Array<voucherModel> = [];
  list_voucher_filter: Array<voucherModel> = [];
  update_bill_id: any;
  list_product_filter: Array<billDetailModel> = [];
  list_bill_detail: Array<billDetailModel> = [];
  list_bill_filter: Array<billModel> = [];
  total = 0;
  total_money = 0;
  mailModel:mailModel;
  billDetailModel: billDetailModel;
  itemModel: ItemModel;
  checkCart :boolean;
  hidden: boolean;
  account: accountModel;
  voucherModel: voucherModel;
  bill_id: any;
  bill_detail_id: any;
  billModel: any;
  account_id: any;
  voucher: any;
  submitted = false;
  searchedKeyword: string;
  formGroup: FormGroup;
  update_customer_name: any;
  update_email: any;
  update_phone_number: any;
  update_address: any;
  selectedType: any;
  checkVoucher: boolean;
  modalReference: any;
  closeResult: string;
  constructor(private cartService: CartService,
    private fb: FormBuilder,
    private productService: ProductService,
    private billService: BillService,
    private billDetailService: BillDetailService,
    private accountService: AccountService,
    private router: Router,
    private toastr: ToastrService,
    private voucherService: VoucherService,
    private modalService: NgbModal,
    private mailService:MailService) { }

  ngOnInit(): void {
    this.hidden = true;
    this.submitted = true;
    this.selectedType = 0;
    this.loadListProductCart();
    this.formGroup = new FormGroup({
      name: new FormControl(),
      email:new FormControl(),
      note: new FormControl(),
      phone_number: new FormControl(),
      address: new FormControl()
    });
  }

  CaptureData() {
    //cach 1
    var data = document.getElementById("product_cart_capture");
    htmlToImage.toJpeg(data, { quality: 0.95 }).then(function (canvas) {
      const link: any = document.createElement("a");
      document.body.appendChild(link);
      link.download = "html_image.png";
      link.href = canvas;
      link.click();
    });
    //cach 2
    // html2canvas(document.getElementById("product_cart_capture")).then(canvas => {
    //   this.canvas.nativeElement.src = canvas.toDataURL();
    //   this.downloadLink.nativeElement.href = canvas.toDataURL('image/png');
    //   this.downloadLink.nativeElement.download = 'marble-diagram.png';
    //   this.downloadLink.nativeElement.click();
    // });
    //cach 3
    // var data = document.getElementById("product_cart_capture");
    // html2canvas(data).then(function(canvas){
    //   var generatedImage = canvas.toDataURL("image/png").replace("image/png","image/octet-stream");
    //   console.log(generatedImage);
    //   window.location.href = generatedImage;
    // })
  }


  selectcontinue() {
    this.router.navigate(['/']);
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
            if(this.list_product_filter !== []){     
              this.list_product = this.list_product_filter.filter(product => product.bill_id === this.list_bill_filter[0].bill_id);
              if (this.list_product.length !== 0) {
                // localStorage.setItem("listProduct", JSON.stringify(this.list_product));
                this.bill_detail_id = this.list_product[0].bill_detail_id;
              }
            }
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
          name: [this.update_customer_name],
          email:[this.update_email],
          note: [],
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
          // localStorage.setItem("listProduct", JSON.stringify(this.list_product));
        }
      }
    }
    // console.log(this.list_product);

    setTimeout(() => this.totalCart(), 1000);

    // if(this.list_product === [] || this.list_product.length === 0){
    //   this.checkCart = false;
    // }
  }


  public filterByKeyword() {
    var filterResult = [];
    this.voucherService.detail(localStorage.getItem("account_id")).subscribe(data => {
      this.list_voucher = data.data;
      if (this.searchedKeyword === null || this.searchedKeyword.length === 0) {
        // this.checkVoucher = false;
        this.list_voucher_filter = null;
      } else {
        // this.checkVoucher = true;
        this.list_voucher_filter = this.list_voucher;
        var keyword = this.searchedKeyword.toString();
        for (let item of this.list_voucher_filter) {
          var voucher_id = item.voucher_id.toString();
          if (voucher_id === keyword) {
            filterResult.push(item);
          }
        }
        if (filterResult.length === 0) {
          // this.checkVoucher = true;
          this.list_voucher_filter = null;
        } else {
          // this.checkVoucher = false;
          this.list_voucher_filter = filterResult;
        }
      }
    })

  }

  useVouvher() {
    if (this.list_voucher_filter.length !== 0) {
      this.total_money = (this.total * ((100 - this.list_voucher_filter[0].voucher_level) / 100));
      // localStorage.setItem("total_money", this.total_money.toString());
    } else {
      this.total_money = this.total;
      // localStorage.setItem("total_money", this.total_money.toString());
    }

  }


  orderSuccess() {
    // console.log(this.formGroup);
    this.submitted = false;
    this.list_bill = [];
    this.list_bill_filter = [];
    let account: accountModel;
    let bill: billModel;
    let account_id = Number(localStorage.getItem("account_id"));
    if (localStorage.getItem("account_id")) {
      // account = {
      //   email: this.formGroup.get('email')?.value,
      //   full_name: this.formGroup.get('customer_name')?.value,
      //   phone_number: this.formGroup.get('phone_number')?.value,
      //   address: this.formGroup.get('address')?.value,
      // }
      // this.accountService.update(account).subscribe(data => {
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

            if (this.list_voucher_filter.length !== 0) {
              const modelDelete = {
                id: this.list_voucher_filter[0].voucher_id
              };
              this.voucherService.delete(modelDelete).subscribe(data => {
              })
              bill = {
                order_status_id: 2,
                phone_number: this.formGroup.get('phone_number')?.value,
                address: this.formGroup.get('address')?.value,
                note: this.formGroup.get('note')?.value,
                email: this.formGroup.get('email')?.value,
                name: this.formGroup.get('name')?.value,
                order_type_id: this.selectedType,
                into_money: this.total_money,
              }
              this.billService.update(this.list_bill_filter[0].bill_id, bill).subscribe(data => {
                this.cartService.clearCart();
                this.toastr.success("Đặt hàng thành công");
                this.mailModel = {
                  name: this.formGroup.get('name')?.value,
                  email:this.formGroup.get('email')?.value,
                  phone_number: this.formGroup.get('phone_number')?.value,
                  address: this.formGroup.get('address')?.value,
                  note: this.formGroup.get('note')?.value,
                  total_money:this.total_money,
                  listProduct:this.list_product,
                }
                this.mailService.sendEmail(this.mailModel).subscribe();
                this.router.navigate(['/send-cart']);
               
              })
            } else {
              bill = {
                order_status_id: 2,
                order_type_id: this.selectedType,
                email:this.formGroup.get('email')?.value,
                phone_number: this.formGroup.get('phone_number')?.value,
                address: this.formGroup.get('address')?.value,
                note: this.formGroup.get('note')?.value,
                name: this.formGroup.get('name')?.value,
              }
              this.billService.update(this.list_bill_filter[0].bill_id, bill).subscribe(data => {
                this.cartService.clearCart();
                this.toastr.success("Đặt hàng thành công");
                this.mailModel = {
                  name: this.formGroup.get('name')?.value,
                  email:this.formGroup.get('email')?.value,
                  phone_number: this.formGroup.get('phone_number')?.value,
                  address: this.formGroup.get('address')?.value,
                  note: this.formGroup.get('note')?.value,
                  total_money:this.total_money,
                  listProduct:this.list_product,
                }
                this.mailService.sendEmail(this.mailModel).subscribe();
                this.router.navigate(['/send-cart']);
              })
            }

          }
        }
      })
    } else {
      if (this.formGroup.get('phone_number')?.value !== undefined && this.formGroup.get('address')?.value !== null && this.formGroup.get('name')?.value !== null && this.formGroup.get("email")?.value !== null
        && this.formGroup.get('phone_number')?.value !== "" && this.formGroup.get('address')?.value !== "" && this.formGroup.get('name')?.value !== "" && this.formGroup.get('email')?.value !== "") {
        if (this.selectedType === 0) {
          this.toastr.warning("Vui lòng chọn hình thức thanh toán");
        } else {
          bill = {
            phone_number: this.formGroup.get('phone_number')?.value,
            address: this.formGroup.get('address')?.value,
            email: this.formGroup.get("email")?.value,
            note: this.formGroup.get('note')?.value,
            name: this.formGroup.get('name')?.value,
            order_type_id: this.selectedType
          }
          this.billService.createNotAccount(bill).subscribe(data => {

            if (this.list_product !== []) {
              for (let item of this.list_product) {
                this.billDetailModel = {
                  bill_id: data.data.bill_id,
                  product_id: item.product_id,
                  amount: item.amount,
                  price: item.price,
                }
              }
              this.billDetailService.createNoAccount(this.billDetailModel).subscribe(data => {
                this.cartService.clearCart();
                this.toastr.success("Đặt hàng thành công");
                this.mailModel = {
                  name: this.formGroup.get('name')?.value,
                  email:this.formGroup.get('email')?.value,
                  phone_number: this.formGroup.get('phone_number')?.value,
                  address: this.formGroup.get('address')?.value,
                  note: this.formGroup.get('note')?.value,
                  total_money:this.total_money,
                  listProduct:this.list_product,
                }
                this.mailService.sendEmail(this.mailModel).subscribe();
                this.router.navigate(['/send-cart']);
              })
            }

          })
        }

      } else {
        this.toastr.error("Vui lòng nhập đầy đủ thông tin khách hàng");
        return;
      }
      // if (this.formGroup.invalid) {
      //   this.toastr.error('Vui lòng điền đầy đủ thông tin khách hàng.');
      //   return;
      // }
      // console.log(this.list_product);

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
            // console.log(this.list_product);
            if(this.list_product.length === 0){
              this.checkCart = false;
            }else{
              this.checkCart = true;
            }
            if (this.list_product !== null) {
              for (let i of this.list_product) {
                this.total += i.amount * i.price;
              }
              this.total_money = this.total;
              
              // localStorage.setItem("total_money", this.total_money.toString());
            }
            else {
            }
          },
            err => {
            })
        }
      })
      // console.log(this.formGroup);
    }
    else {
      this.total = 0;
      this.list_item = this.cartService.getItems();
      if(this.list_product.length === 0){
        this.checkCart = false;
      }else{
        this.checkCart = true;
      }
      if (this.list_product !== null) {
        for (let i of this.list_product) {
          this.total += i.amount * i.price;
        }
        this.total_money = this.total;
        // localStorage.setItem("total_money", this.total_money.toString());
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
          this.toastr.success("Xóa giỏ hàng thành công");
          this.cartService.clearCart();
        });
      })

    } else {
      this.cartService.clearCart();
      this.totalCart();
    }
    setTimeout( () => {
      this.loadListProductCart();
      this.modalReference.dismiss();
    }, 1000);
    this.checkCart = false;
    
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
            this.loadListProductCart();
          })
        }
      })

    }
    else {
      this.cartService.deleteItem(item);
      this.loadListProductCart();
    }
    this.modalReference.dismiss();
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
        list_bill_filter = this.list_bill.filter(bill => bill.customer_id === account && bill.order_status_id === 1);
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
        list_bill_filter = this.list_bill.filter(bill => bill.customer_id === account && bill.order_status_id === 1);
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
