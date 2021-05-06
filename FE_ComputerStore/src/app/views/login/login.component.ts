import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../models/account-model';
import { billDetailModel } from '../../models/bill-detail-model';
import { billModel } from '../../models/bill-model';
import { ItemModel } from '../../models/item-model';
import { AccountService } from '../../services/account/account.service';
import { BillDetailService } from '../../services/bill-detail/bill-detail.service';
import { BillService } from '../../services/bill/bill.service';
import { CartService } from '../../services/cart/cart.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: 'login.component.html'
})
export class LoginComponent {

  formLogin: FormGroup;
  account: accountModel;
  submitted = false;
  check_bill: boolean;
  billModel: billModel;
  billDetailModel: billDetailModel;
  account_id: any;
  list_bill: Array<billModel> = [];
  list_item: Array<ItemModel> = [];
  update_bill_id: any;


  constructor(private fb: FormBuilder, private accountService: AccountService, private router: Router, private toaster: ToastrService,
    private billService: BillService, private billDetailService: BillDetailService, private cartService: CartService) {

  }
  ngOnInit(): void {
    this.createForm();
    // if (!localStorage.getItem('foo')) {
    //   localStorage.setItem('foo', 'no reload')
    //   location.reload()
    // } else {
    //   localStorage.removeItem('foo')
    // }
  }
  createForm() {
    this.formLogin = this.fb.group({
      email: [null, [Validators.required, Validators.pattern(new RegExp(/^(.{10,})$/))]],
      password: [null, [Validators.required, Validators.pattern(new RegExp(/^(.{8,})$/))]],
    });
  }

  Login() {
    this.submitted = true;
    if (this.formLogin.invalid) {
      this.toaster.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    this.account = {
      email: this.formLogin.controls.email.value,
      password: this.formLogin.controls.password.value
    };
    this.accountService.login(this.account).subscribe(res => {
      if (res.token) {
        localStorage.setItem('Token', res.token);
        localStorage.setItem('account_id', res.data.account_id);
        localStorage.setItem('account_type_id', res.data.account_type_id);
        localStorage.setItem('full_name', res.data.full_name);
        this.account_id = res.data.account_id;
        this.toaster.success('Đăng nhập thành công');
        if (res.data.account_type_id == "3") {
          let update_bill_id;
          this.check_bill = false;
          this.list_bill = [];
          this.account_id = 0;
          let list_bill_filter = this.list_bill;
          this.billService.getAll().subscribe(data => {
            this.list_bill = data.data;
            list_bill_filter = this.list_bill;
            this.account_id = Number(localStorage.getItem("account_id"));
            if (this.cartService.getItems() !== null && this.account_id !== 0) {
              if (list_bill_filter.length !== 0) {
                for (let item of list_bill_filter) {
                  if (item.customer_id === this.account_id && item.order_status_id === 1) {
                    this.check_bill = true;
                    update_bill_id = item.bill_id;
                    this.list_item = this.cartService.getItems();
                    if (this.list_item !== null) {
                      for (let item of this.list_item) {
                        this.billDetailModel = {
                          bill_id: update_bill_id,
                          product_id: item.product.product_id,
                          price: item.product.price_display,
                          amount: item.quantity,
                        }
                        this.billDetailService.create(this.billDetailModel).subscribe(data => {
                          // this.list_item = this.cartService.getItems();
                          // if (this.list_item !== null) {
                          //   for (let item of this.list_item) {
                          //     this.billDetailModel = {
                          //       bill_id: data.data[0].bill_id,
                          //       product_id: item.product.product_id,
                          //       price: item.product.price_display,
                          //       amount: item.quantity,
                          //     }
                          //     this.billDetailService.create(this.billDetailModel).subscribe(data => {
                          //       data.data.success();
                          //     });
                          //   }
                          // }
                        });
                      }
                    }
                  }
                }
                if (this.check_bill === false) {
                  this.billModel = {
                    customer_id: this.account_id,
                  }
                  this.billService.create(this.billModel).subscribe(data => {
                    this.list_item = this.cartService.getItems();
                    if (this.list_item !== null) {
                      for (let item of this.list_item) {
                        this.billDetailModel = {
                          bill_id: data.data[0].bill_id,
                          product_id: item.product.product_id,
                          price: item.product.price_display,
                          amount: item.quantity,
                        }
                        this.billDetailService.create(this.billDetailModel).subscribe(data => {
                          data.data.success();
                        });
                      }
                    }
                  });
                }
              }

              else {
                this.billModel = {
                  customer_id: this.account_id,
                }
                this.billService.create(this.billModel).subscribe(data => {
                  this.list_item = this.cartService.getItems();
                  if (this.list_item !== null) {
                    for (let item of this.list_item) {
                      this.billDetailModel = {
                        bill_id: data.data[0].bill_id,
                        product_id: item.product.product_id,
                        price: item.product.price_new,
                        amount: item.quantity,
                      }
                      this.billDetailService.create(this.billDetailModel).subscribe(data => {
                        data.data.success();
                      });
                    }
                  }
                });

              }
              // }


            }
          }, err => {
          })
          this.router.navigate(['']);
        }
        else {
          this.router.navigate(['/admin/dashboard']);
        }

      }
      if (res.error) {
        this.toaster.error("Sai mật khẩu, vui lòng nhập lại");
      }
    },
      err => {
        this.toaster.error("tài khoản không tồn tại");
      });
  }
}
