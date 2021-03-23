import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../models/account-model';
import { AccountService } from '../../services/account/account.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: 'login.component.html'
})
export class LoginComponent { 

  formLogin: FormGroup;
  account: accountModel;
  submitted = false;
  constructor(private fb: FormBuilder, private accountService: AccountService, private router: Router, private toaster: ToastrService) {

  }
  ngOnInit(): void {
    this.createForm();
    if (!localStorage.getItem('foo')) { 
      localStorage.setItem('foo', 'no reload') 
      location.reload() 
    } else {
      localStorage.removeItem('foo') 
    }
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
        this.toaster.success('Đăng nhập thành công');
        if(res.data.account_type_id=="3")
        {
          this.router.navigate(['']);
        }
        else{
          this.router.navigate(['/admin/dashboard']);
        }
        
      }
      if(res.error) {
        this.toaster.error("Sai mật khẩu, vui lòng nhập lại");
      }  
    },
    err => {
      this.toaster.error("tài khoản không tồn tại");
    });
  }
}
