import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { forgotPasswordModel } from '../../models/forgot-password-model';
import { MailService } from '../../services/mail/mail.service';

@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.scss']
})
export class ForgotPasswordComponent implements OnInit {

  formForgotPassword: FormGroup;
  email: any;
  code:any;
  numbercode:any;
  checkCode:boolean;
  forgotPasswordModel:forgotPasswordModel;
  constructor(private mailService:MailService,private router: Router, private toaster: ToastrService,private fb: FormBuilder,) { 
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

  SendEmail(){
    if (this.formForgotPassword.invalid) {
      this.toaster.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
      this.numbercode= Math.floor((Math.random() * (999999-100000 + 1)))+1;
      this.forgotPasswordModel = {
        email:this.formForgotPassword.get("email")?.value,
        code:this.numbercode
      }
      this.mailService.sendcode(this.forgotPasswordModel).subscribe(data =>{
        this.checkCode = false;
        this.toaster.success(data.success);
      });
  }

  acceptCode(){
    if(this.code.toString() === this.numbercode.toString()){
      localStorage.setItem("emailReset",this.formForgotPassword.get("email")?.value);
      this.router.navigate(['/reset-password']);
    }else{
      this.toaster.error("Mã xác nhận không đúng, vui lòng kiểm tra lại !!!");
    }
  }
}
