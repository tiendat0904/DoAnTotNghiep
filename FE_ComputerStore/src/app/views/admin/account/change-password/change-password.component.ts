import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../../../models/account-model';
import { AccountService } from '../../../../services/account/account.service';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.scss']
})
export class ChangePasswordComponent implements OnInit {

  formGroup: FormGroup;
  constructor( private accountService: AccountService,
    private toastr: ToastrService,private fb: FormBuilder,private router: Router) { }

  ngOnInit(): void {
    this.formGroup = new FormGroup({
      old_password: new FormControl(),
      new_password: new FormControl(),
      confirm_password: new FormControl(),
    });
  }

  save() {
    let account: accountModel;
    account = {
      email: localStorage.getItem("email"),
      old_password: this.formGroup.get("old_password").value,
      new_password: this.formGroup.get("new_password").value,
      confirm_password: this.formGroup.get("confirm_password").value,
    }
      
      if(account.confirm_password === null || account.new_password === null || account.old_password === null)
      {
        this.toastr.warning("vui lòng nhập đủ số trường");
      }
      else{
        if(account.confirm_password === account.new_password){
          this.accountService.update(account).subscribe(res => {
            this.router.navigate(['/admin/account/account-info']);
            this.toastr.success("Thay đổi mật khẩu thành cống");
          },
        err => {
          this.toastr.error(err.error.error);
        }
        );
        }else{
          this.toastr.error("mật khẩu mới không trùng khớp, vui lòng nhập lại");
        }
      }
      
      
      
    }


}
