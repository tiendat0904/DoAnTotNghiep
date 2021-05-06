import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../models/account-model';
import { AccountService } from '../../services/account/account.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: 'register.component.html'
})
export class RegisterComponent {

  formRegister: FormGroup;
  //avatarUrlDefaut = avatarDefault;
  submitted = false;
  user: accountModel;
  confirm_password: string;

  constructor(private authService: AccountService, private toastr: ToastrService, private fb: FormBuilder, private router: Router) {
    this.createForm();

  }

  ngOnInit(): void {
    // if (!localStorage.getItem('foo')) { 
    //   localStorage.setItem('foo', 'no reload') 
    //   location.reload() 
    // } else {
    //   localStorage.removeItem('foo') 
    // }
  }

  createForm() {
    this.formRegister = this.fb.group({
      email: [null, [Validators.required, Validators.pattern(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i)]],
      password: [null, [Validators.required, Validators.pattern(new RegExp(/^(.{8,})$/))]],
      full_name: [null, ],
      address: [null, ],
      phone_number: [ null, [Validators.pattern(new RegExp('[0-9]{10}'))]],
      confirm_password: [null, [Validators.required, Validators.pattern(new RegExp(/^(.{8,})$/))]], 
    });
  }

  save() {
    this.submitted = true;
    if (this.formRegister.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    this.confirm_password = this.formRegister.get('confirm_password').value;
    const password = this.formRegister.get('password')?.value;
    if (this.confirm_password !== password) {
      this.toastr.error('Mật khẩu xác nhận không khớp');
      return;
    }
    this.user = {
      email: this.formRegister.get('email')?.value,
      password: this.formRegister.get('password')?.value,
      full_name: this.formRegister.get('full_name')?.value,
      address: this.formRegister.get('address')?.value,
      phone_number: this.formRegister.get('phone_number')?.value,
    };
    this.authService.register(this.user).subscribe(res => {
          this.router.navigate(['/login']);
          this.toastr.success('Thêm mới thành công');
      },
      err => {
        this.toastr.error('Có lỗi xảy ra!');
      });
  }

}
