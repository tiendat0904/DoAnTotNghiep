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
import { LoaderService } from '../../../loader/loader.service';
import { Title } from '@angular/platform-browser';
import { voucherCustomerModel } from '../../../models/voucher-customer-model';
import { VoucherCustomerServiceService } from '../../../services/voucher-customer-service/voucher-customer-service.service';
import { DatePipe } from '@angular/common';
declare var $: any;

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit {

  list_item: Array<ItemModel> = [];
  list_product: Array<billDetailModel> = [];
  list_bill: Array<billModel> = [];
  list_voucher: Array<voucherCustomerModel> = [];
  list_voucher_filter: Array<voucherCustomerModel> = [];
  list_product_filter: Array<billDetailModel> = [];
  list_bill_detail: Array<billDetailModel> = [];
  list_bill_filter: Array<billModel> = [];
  update_bill_id: any;
  total = 0;
  total_money = 0;
  mailModel: mailModel;
  billDetailModel: billDetailModel;
  itemModel: ItemModel;
  checkCart: boolean;
  account: accountModel;
  voucherModel: voucherCustomerModel;
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
  checkVoucher1: boolean;
  modalReference: any;
  closeResult: string;


  constructor(private cartService: CartService,
    private fb: FormBuilder,
    // private productService: ProductService,
    private datePipe: DatePipe,
    private billService: BillService,
    private billDetailService: BillDetailService,
    private accountService: AccountService,
    private router: Router,
    private toastr: ToastrService,
    private voucherService: VoucherCustomerServiceService,
    private modalService: NgbModal,
    private mailService: MailService,
    private titleService: Title,
    public loaderService: LoaderService) { 
      this.formGroup = new FormGroup({
        name: new FormControl(),
        email: new FormControl(),
        note: new FormControl(),
        phone_number: new FormControl(),
        address: new FormControl()
      });
    }

  ngOnInit(): void {
    this.submitted = true;
    this.selectedType = 0;
    this.loadListProductCart();
  }

  CaptureData() {
    var data = document.getElementById("product_cart_capture");
    htmlToImage.toJpeg(data, { quality: 0.95 }).then(function (canvas) {
      const link: any = document.createElement("a");
      document.body.appendChild(link);
      link.download = "html_image.png";
      link.href = canvas;
      link.click();
    });
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
    this.titleService.setTitle("Th??ng tin gi??? h??ng");
    this.searchedKeyword = '';
    this.checkCart = true;
    this.list_product = [];
    this.list_bill = [];
    this.update_bill_id = localStorage.getItem("bill_id");
    let account_id = 0;
    account_id = Number(localStorage.getItem("account_id"));
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        this.list_bill_filter = this.list_bill.filter(function (laptop) {
          return (laptop.customer_id === account_id && laptop.order_status_id === 1);
        });
        if(this.list_bill_filter.length !== 0){
          this.checkCart = true;
        }else{
          this.checkCart = false;
        }
        if (this.list_bill_filter.length !== 0) {
          this.billDetailService.getbybill(this.list_bill_filter[0].bill_id).subscribe(data => {
            this.list_product = data.data;
            if (this.list_product.length !== 0) {
              this.checkCart = true;
              this.bill_detail_id = this.list_product[0].bill_detail_id;
            } else {
              this.checkCart = false;
            }
          })
        } else {
          this.list_product = [];
        }
      })
      this.accountService.getInfo().subscribe(data => {
        this.update_customer_name = data.data.full_name;
        this.update_email = data.data.email;
        this.update_phone_number = data.data.phone_number;
        this.update_address = data.data.address;
        this.formGroup = this.fb.group({
          name: [this.update_customer_name],
          email: [this.update_email],
          note: [],
          phone_number: [this.update_phone_number],
          address: [this.update_address],
        });
      })
    } else {
      this.list_item = [];
      this.list_item = this.cartService.getItems();
      if (this.list_item === null) {
        this.list_item = [];
      }
      if (this.list_item.length !== 0) {
        this.checkCart = true;
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
      } else {
        this.checkCart = false;
      }
    }
    this.totalCart();
  }

  public filterByKeyword() {
    var filterResult = [];
    this.checkVoucher = false;
    this.checkVoucher1 = false;
    this.voucherService.detail(localStorage.getItem("account_id")).subscribe(data => {
      this.list_voucher = data.data;
      if (this.searchedKeyword === null || this.searchedKeyword.length === 0) {
        this.list_voucher_filter = null;
        this.total_money = this.total;
      } else {
        this.list_voucher_filter = this.list_voucher.filter(voucher => (voucher.status === "Ch??a s??? d???ng" && this.datePipe.transform(new Date, "dd/MM/yyyy") >= this.datePipe.transform(voucher.startDate, "dd/MM/yyyy")  && this.datePipe.transform(new Date, "dd/MM/yyyy") <= this.datePipe.transform(voucher.endDate, "dd/MM/yyyy")));
        var keyword = this.searchedKeyword.toString();
        for (let item of this.list_voucher_filter) {
          var voucher_id = item.voucher_customer_id.toString();
          if (voucher_id === keyword) {
            filterResult.push(item);
          }
        }
        if (filterResult.length === 0 || filterResult === []) {
          this.list_voucher_filter = null;
          this.checkVoucher1 = true;
        } else {
          this.checkVoucher = true;
          this.list_voucher_filter = filterResult;
        }
      }
    })
  }

  useVouvher() {
    if (this.list_voucher_filter.length !== 0) {
      this.total_money = (this.total * ((100 - this.list_voucher_filter[0].voucher_level) / 100));
    } else {
      this.total_money = this.total;
    }
  }

  orderSuccess() {
    this.submitted = false;
    this.list_bill = [];
    this.list_bill_filter = [];
    let bill: billModel;
    let account_id = Number(localStorage.getItem("account_id"));
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.list_bill = data.data;
        this.list_bill_filter = this.list_bill.filter(function (laptop) {
          return (laptop.customer_id === account_id && laptop.order_status_id === 1);
        });
        if (this.list_bill_filter.length === 0) {
          this.toastr.warning("Gi??? h??ng tr???ng, vui l??ng th??m s???n ph???m v??o gi??? h??ng", 'www.tiendatcomputer.vn cho bi???t');
        }
        else {
          if (this.selectedType === 0) {
            this.toastr.warning("Vui l??ng ch???n h??nh th???c thanh to??n", 'www.tiendatcomputer.vn cho bi???t');
          } else {
            if (this.list_voucher_filter.length !== 0) {
              let voucher: voucherCustomerModel;
              voucher = {
                voucher_customer_id :this.list_voucher_filter[0].voucher_customer_id,
                status : "???? s??? d???ng"
              }
              this.voucherService.update(this.list_voucher_filter[0].voucher_id,voucher).subscribe();
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
                this.toastr.success("?????t h??ng th??nh c??ng", 'www.tiendatcomputer.vn cho bi???t');
                this.mailModel = {
                  name: this.formGroup.get('name')?.value,
                  email: this.formGroup.get('email')?.value,
                  phone_number: this.formGroup.get('phone_number')?.value,
                  address: this.formGroup.get('address')?.value,
                  note: this.formGroup.get('note')?.value,
                  total_money: this.total_money,
                  listProduct: this.list_product,
                }
                this.mailService.sendEmail(this.mailModel).subscribe();
                this.router.navigate(['/send-cart']);

              })
            } else {
              bill = {
                order_status_id: 2,
                order_type_id: this.selectedType,
                email: this.formGroup.get('email')?.value,
                phone_number: this.formGroup.get('phone_number')?.value,
                address: this.formGroup.get('address')?.value,
                note: this.formGroup.get('note')?.value,
                name: this.formGroup.get('name')?.value,
              }
              this.billService.update(this.list_bill_filter[0].bill_id, bill).subscribe(data => {
                this.cartService.clearCart();
                this.toastr.success("?????t h??ng th??nh c??ng", 'www.tiendatcomputer.vn cho bi???t');
                this.mailModel = {
                  name: this.formGroup.get('name')?.value,
                  email: this.formGroup.get('email')?.value,
                  phone_number: this.formGroup.get('phone_number')?.value,
                  address: this.formGroup.get('address')?.value,
                  note: this.formGroup.get('note')?.value,
                  total_money: this.total_money,
                  listProduct: this.list_product,
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
          this.toastr.warning("Vui l??ng ch???n h??nh th???c thanh to??n", 'www.tiendatcomputer.vn cho bi???t');
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
                this.billDetailService.createNoAccount(this.billDetailModel).subscribe();
              }
              this.cartService.clearCart();
              this.toastr.success("?????t h??ng th??nh c??ng", 'www.tiendatcomputer.vn cho bi???t');
              this.mailModel = {
                name: this.formGroup.get('name')?.value,
                email: this.formGroup.get('email')?.value,
                phone_number: this.formGroup.get('phone_number')?.value,
                address: this.formGroup.get('address')?.value,
                note: this.formGroup.get('note')?.value,
                total_money: this.total_money,
                listProduct: this.list_product,
              }
              this.mailService.sendEmail(this.mailModel).subscribe();
              this.router.navigate(['/send-cart']);
            }
          })
        }
      } else {
        this.toastr.error("Vui l??ng nh???p ?????y ????? th??ng tin kh??ch h??ng", 'www.tiendatcomputer.vn cho bi???t');
        return;
      }
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
          this.billDetailService.getbybill(this.list_bill_filter[0].bill_id).subscribe(data => {
            this.list_product = data.data;
            if (this.list_product !== null) {
              for (let i of this.list_product) {
                this.total += i.amount * i.price;
              }
              this.total_money = this.total;
            }
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
        this.total_money = this.total;
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
          this.toastr.success("X??a gi??? h??ng th??nh c??ng", 'www.tiendatcomputer.vn cho bi???t');
          this.cartService.clearCart();
        });
      })
    } else {
      this.toastr.success("X??a gi??? h??ng th??nh c??ng", 'www.tiendatcomputer.vn cho bi???t');
      this.cartService.clearCart();
    }
    setTimeout(() => {
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
        list_bill_detail_filter = this.list_bill_detail.filter(bill_detail => (bill_detail.product_id === item && bill_detail.bill_id === this.list_bill_filter[0].bill_id));
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
            bill_id : list_bill_detail_filter[0].bill_id,
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
