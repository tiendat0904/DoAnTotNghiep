import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../models/account-model';
import { forgotPasswordModel } from '../../models/forgot-password-model';
import { AccountService } from '../../services/account/account.service';
import { MailService } from '../../services/mail/mail.service';

@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.scss']
})
export class ForgotPasswordComponent implements OnInit {

  formForgotPassword: FormGroup;
  list_account: Array<accountModel> = [];
  list_account_filter: Array<accountModel> = [];
  email: any;
  code: any;
  numbercode: any;
  checkCode: boolean;
  forgotPasswordModel: forgotPasswordModel;
  constructor(
    private mailService: MailService,
    private router: Router,
    private toaster: ToastrService,
    private fb: FormBuilder,
    private accountService: AccountService) {
    this.createForm();
  }

  ngOnInit(): void {
    this.email = null;
    this.code = null;
    this.checkCode = true;
  }

  createForm() {
    this.formForgotPassword = this.fb.group({
      email: [null, [Validators.required, Validators.pattern(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i)]],
    });
  }

  SendEmail() {
    if (this.formForgotPassword.invalid) {
      this.toaster.error('Kiểm tra thông tin các trường đã nhập',"www.tiendatcomputer.vn cho biết");
      return;
    }
    this.accountService.getAccountCustomer().subscribe(data =>{
      this.list_account = data.data;
      this.list_account_filter = this.list_account.filter(account => account.email === this.formForgotPassword.get("email")?.value);
      if(this.list_account_filter.length === 0){
        this.toaster.error('Không tồn tại tài khoản email trong hệ thống, vui lòng kiếm tra lại',"www.tiendatcomputer.vn cho biết");
        return;
      }else{
        this.numbercode = Math.floor((Math.random() * (999999 - 100000 + 1))) + 1;
        this.forgotPasswordModel = {
          email: this.formForgotPassword.get("email")?.value,
          code: this.numbercode
        }
        this.mailService.sendcode(this.forgotPasswordModel).subscribe(data => {
          this.checkCode = false;
          this.toaster.success(data.success, "www.tiendatcomputer.vn cho biết");
        });
      }
    })
    
  }

  acceptCode() {
    if (this.code.toString() === this.numbercode.toString()) {
      localStorage.setItem("emailReset", this.formForgotPassword.get("email")?.value);
      this.router.navigate(['/reset-password']);
    } else {
      this.toaster.error("Mã xác nhận không đúng, vui lòng kiểm tra lại !!!", "www.tiendatcomputer.vn cho biết");
    }
  }
}
