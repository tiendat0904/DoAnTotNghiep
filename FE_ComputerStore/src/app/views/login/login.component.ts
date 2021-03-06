import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../models/account-model';
import { billDetailModel } from '../../models/bill-detail-model';
import { billModel } from '../../models/bill-model';
import { ItemModel } from '../../models/item-model';
import { BuildPCModel } from '../../models/pc-model';
import { AccountService } from '../../services/account/account.service';
import { BillDetailService } from '../../services/bill-detail/bill-detail.service';
import { BillService } from '../../services/bill/bill.service';
import { CartService } from '../../services/cart/cart.service';
import { PcService } from '../../services/pc/pc.service';
import { SocialAuthService } from "angularx-social-login";
import { FacebookLoginProvider, GoogleLoginProvider } from "angularx-social-login";
@Component({
  selector: 'app-dashboard',
  templateUrl: 'login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {

  formLogin: FormGroup;
  account: accountModel;
  billModel: billModel;
  billDetailModel: billDetailModel;
  array_buildpc = [];
  array_buildpc_filter: Array<BuildPCModel> = [];
  array_pc: [];
  array_pc_customer: Array<BuildPCModel> = [];
  list_bill: Array<billModel> = [];
  list_item: Array<ItemModel> = [];
  submitted = false;
  check_bill: boolean;
  account_id: any;
  update_bill_id: any;
  response;  
  socialusers: accountModel;  

  constructor(
    private fb: FormBuilder,
    private accountService: AccountService,
    private router: Router, private toaster: ToastrService,
    private billService: BillService,
    private billDetailService: BillDetailService,
    private cartService: CartService,
    private pcService: PcService,
    private authService: SocialAuthService) { }

  ngOnInit(): void {
    this.createForm();
  }

  signInWithFB(): void {
    this.authService.signIn(FacebookLoginProvider.PROVIDER_ID).then((data) => {
      const user :accountModel = {
        email: data.email,
        full_name : data.name,
        image:data.photoUrl
      }
      this.accountService.loginbysocal(user).subscribe(data=>{
        localStorage.setItem('Token', data.token);
        localStorage.setItem('account_id', data.data[0].account_id);
        localStorage.setItem('account_type_id', data.data[0].account_type_id);
        localStorage.setItem('full_name', data.data[0].full_name);
        localStorage.setItem('email', data.data[0].email);
        this.toaster.success('????ng nh???p th??nh c??ng');
        this.account_id =data.data[0].account_type_id;
        if (data.data[0].account_type_id == "3") {
          this.addBuildPC();
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
                        this.billDetailService.create(this.billDetailModel).subscribe();
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
            }
          })
          this.router.navigate(['']);
        }
        else {
          this.router.navigate(['/admin/dashboard']);
        }
      });
    })
  }

  signInWithGoogle(): void {
    this.authService.signIn(GoogleLoginProvider.PROVIDER_ID).then((data) => {
      const user :accountModel = {
        email: data.email,
        full_name : data.name,
        image:data.photoUrl
      }
      this.accountService.loginbysocal(user).subscribe(data=>{
        localStorage.setItem('Token', data.token);
        localStorage.setItem('account_id', data.data[0].account_id);
        localStorage.setItem('account_type_id', data.data[0].account_type_id);
        localStorage.setItem('full_name', data.data[0].full_name);
        localStorage.setItem('email', data.data[0].email);
        this.account_id =data.data[0].account_type_id;
        this.toaster.success('????ng nh???p th??nh c??ng');
        if (data.data[0].account_type_id == "3") {
          this.addBuildPC();
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
                        this.billDetailService.create(this.billDetailModel).subscribe();
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
            }
          })
          this.router.navigate(['']);
        }
        else {
          this.router.navigate(['/admin/dashboard']);
        }
      });
    })
    

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
      this.toaster.error('Ki???m tra th??ng tin c??c tr?????ng ???? nh???p');
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
        localStorage.setItem('email', res.data.email);
        this.account_id = res.data.account_id;
        this.toaster.success('????ng nh???p th??nh c??ng');
        if (res.data.account_type_id == "3") {
          this.addBuildPC();
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
                        this.billDetailService.create(this.billDetailModel).subscribe();
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
                        this.billDetailService.create(this.billDetailModel).subscribe();
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
            }
          })
          this.router.navigate(['']);
        }
        else {
          this.router.navigate(['/admin/dashboard']);
        }
      }
      if (res.error) {
        this.toaster.error("Sai m???t kh???u, vui l??ng nh???p l???i");
      }
    },
      err => {
        this.toaster.error(err.error.error);
      });
  }

  addBuildPC() {
    let build_pc_delete = [];
    let pcModel: BuildPCModel;
    this.array_buildpc = this.pcService.getItems();
    if (this.array_buildpc !== null) {
      this.pcService.detail(Number(localStorage.getItem("account_id"))).subscribe(data => {
        this.array_pc_customer = data.data;
        if (this.array_pc_customer !== []) {
          for (let item of this.array_pc_customer) {
            build_pc_delete.push(item.build_pc_id);
          }
          const modelDelete = {
            listId: build_pc_delete
          };
          this.pcService.delete(modelDelete).subscribe(data => {
            for (let item of this.array_buildpc) {
              pcModel = {
                customer_id: Number(localStorage.getItem("account_id")),
                product_id: item.product.product_id,
                price: item.product.price,
                quantity: item.quantity,
              }
              this.pcService.create(pcModel).subscribe();
            }
          })
        } else {
          for (let item of this.array_buildpc) {
            pcModel = {
              customer_id: Number(localStorage.getItem("account_id")),
              product_id: item.product.product_id,
              price: item.product.price,
              quantity: item.quantity,
            }
            this.pcService.create(pcModel).subscribe();
          }
        }
      })
    }
  }

}
