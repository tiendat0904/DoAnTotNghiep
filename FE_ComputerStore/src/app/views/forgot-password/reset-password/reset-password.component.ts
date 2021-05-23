import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../../models/account-model';
import { AccountService } from '../../../services/account/account.service';

@Component({
  selector: 'app-reset-password',
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.scss']
})
export class ResetPasswordComponent implements OnInit, OnDestroy {

  formReset: FormGroup;
  accountModel: accountModel;
  constructor(
    private fb: FormBuilder,
    private accountService: AccountService,
    private router: Router,
    private toaster: ToastrService,) {
    this.createForm();
  }
  ngOnDestroy(): void {
    localStorage.removeItem("emailReset");
  }

  ngOnInit(): void {
  }

  ChangePassword() {
    if (this.formReset.invalid) {
      this.toaster.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (localStorage.getItem("emailReset")) {
      if (this.formReset.get("password")?.value !== this.formReset.get("confirm_password")?.value) {
        this.toaster.error('Mật khẩu xác nhận không khớp');
        return;
      }
      this.accountModel = {
        email: localStorage.getItem("emailReset"),
        new_password: this.formReset.get("password")?.value,
      }
      this.accountService.resetPassword(this.accountModel).subscribe(data => {
        this.toaster.success("Thay đổi mật khẩu thành công");
        this.router.navigate(['/login']);
      });
    } else {
      this.toaster.error("Lỗi");
    }
  }

  createForm() {
    this.formReset = this.fb.group({
      email: [localStorage.getItem("emailReset")],
      password: [null, [Validators.required, Validators.pattern(new RegExp(/^(.{8,})$/))]],
      confirm_password: [null, [Validators.required, Validators.pattern(new RegExp(/^(.{8,})$/))]],
    });
  }

}
