import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { avatarDefault } from '../../../../../environments/environment';
import { accountModel } from '../../../../models/account-model';
import { AccountService } from '../../../../services/account/account.service';

@Component({
  selector: 'app-account-info',
  templateUrl: './account-info.component.html',
  styleUrls: ['./account-info.component.scss']
})
export class AccountInfoComponent implements OnInit {

  account: accountModel;
  picture: any;
  urlPictureDefault = avatarDefault;
  formGroup: FormGroup;

  constructor(
    private accountService: AccountService,
    private fb: FormBuilder,
    private toastr: ToastrService,
    private router: Router) { }

  ngOnInit(): void {
    this.formGroup = new FormGroup({
      full_name: new FormControl(),
      email: new FormControl(),
      address: new FormControl(),
      phone_number: new FormControl(),
    });
    this.fetchgetInfo();
  }

  fetchgetInfo() {
    this.accountService.getInfo().subscribe(data => {
      this.account = data.data;
      this.formGroup = this.fb.group({
        full_name: this.account.full_name,
        email: this.account.email,
        address: this.account.address,
        phone_number: this.account.phone_number,
      });
      if (data.image == null) {
        this.picture = this.urlPictureDefault;
      } else {
        this.picture = data.data.image;
      }
    })
  }

  save() {
    let account: accountModel;
    account = {
      full_name: this.formGroup.get('full_name')?.value,
      email: this.formGroup.get('email')?.value,
      address: this.formGroup.get('address')?.value,
      phone_number: this.formGroup.get('phone_number')?.value,
    }
    this.accountService.update(account).subscribe(res => {
      this.toastr.success("Cập nhật thành công");
    },
      err => {
        this.toastr.error(err.error.error);
      }
    );
  }
}
