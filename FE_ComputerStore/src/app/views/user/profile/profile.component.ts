import { Component, OnInit } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Observable } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../environments/environment';
import { accountModel } from '../../../models/account-model';
import { AccountService } from '../../../services/account/account.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {

  getInfo: Array<accountModel> = [];
  formGroup: FormGroup;
  full_name: any;
  account_id: any;
  email :any;
  address: any;
  old_password: any;
  new_password: any;
  confirm_password: any;
  phone_number : any;
  account_type_id: any;
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  urlPictureDefault = avatarDefault;
  constructor(
    private router: Router,
    private accountService: AccountService,
    private toastr: ToastrService,
    private store: AngularFireStorage,
    private fb: FormBuilder,
    ) {
    }

  ngOnInit(): void {
    this.formGroup = new FormGroup({
      full_name: new FormControl(),
      email : new FormControl(),
      address : new FormControl(),
      account_id : new FormControl(),
      phone_number : new FormControl(),
      old_password: new FormControl(),
      new_password:new FormControl(),
      urlPictureDefault : new FormControl(),
      account_type_id : new FormControl(),
      confirm_password: new FormControl(),

   });
    this.fetchgetInfo();
   
  }

  fetchgetInfo(){
    this.accountService.getInfo().subscribe(data => {
      this.full_name = data.data.full_name;
      this.email = data.data.email;
      this.address = data.data.address;
      this.account_id = data.data.account_id;
      this.phone_number = data.data.phone_number;
      if(data.data.image === null){
        this.urlPictureDefault = avatarDefault;
      }
      else{
        this.urlPictureDefault = data.data.image;
      }
      
      this.account_type_id = data.data.account_type_id;
      this.formGroup = this.fb.group({
        email:[{value: this.email}],
        full_name: [{value: this.full_name}],
        address:  [{value: this.address}],
        old_password:[{value: this.old_password}],
        new_password:[{value: this.new_password}],
        confirm_password:[{value: this.confirm_password}],
        phone_number:  [{value: this.phone_number}],
        hinh_anh : [{value: this.urlPictureDefault}],
        account_type_id:  [{value: this.account_type_id}],
      });
    },)
  }

  save() {
    let account: accountModel;
      
      if(this.confirm_password === null || this.new_password === null || this.old_password === null)
      {
        account = {
          email: this.formGroup.get('email')?.value,
          full_name: this.formGroup.get('full_name')?.value,
          address: this.formGroup.get('address')?.value,
          phone_number: this.formGroup.get('phone_number')?.value,
          image : this.urlPictureDefault,
          account_type_id: this.formGroup.get('account_type_id')?.value,
        };
      }
      else{
        account = {
          email: this.formGroup.get('email')?.value,
          old_password: this.old_password,
          new_password: this.new_password,
          full_name: this.formGroup.get('full_name')?.value,
          address: this.formGroup.get('address')?.value,
          phone_number: this.formGroup.get('phone_number')?.value,
          image : this.urlPictureDefault,
          account_type_id: this.formGroup.get('account_type_id')?.value,
        };
      }
      if(this.confirm_password === this.new_password){
        this.accountService.update(account).subscribe(res => {
          this.toastr.success(res.success, 'www.tiendatcomputer.vn cho biết');
        },
      err => {
        this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
      }
      );
      }else{
        this.toastr.error("mật khẩu mới không trùng khớp, vui lòng nhập lại",'www.tiendatcomputer.vn cho biết');
      }
      
      
    }

    onLogout() {
      localStorage.removeItem('Token');
      localStorage.clear();
      this.router.navigate(['/']); 
    }

    uploadImage(event) {
      // tslint:disable-next-line:prefer-const
      let file = event.target.files[0];
      // tslint:disable-next-line:prefer-const
      let path = `thuonghieu/${file.name}`;
      if (file.type.split('/')[0] !== 'image') {
        return alert('Erreur, ce fichier n\'est pas une image');
      } else {
        // tslint:disable-next-line:prefer-const
        let ref = this.store.ref(path);
        // tslint:disable-next-line:prefer-const
        let task = this.store.upload(path, file);
        this.uploadPercent = task.percentageChanges();
        task.snapshotChanges().pipe(
          finalize(() => {
            this.downloadURL = ref.getDownloadURL();
            this.downloadURL.subscribe(url => {
            this.urlPictureDefault=url;
            });
          }
          )
        ).subscribe();
      }
    }

}
