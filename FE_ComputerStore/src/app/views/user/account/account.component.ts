import { Component, OnInit } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Observable } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../environments/environment';
import { accountModel } from '../../../models/account-model';
import { AccountService } from '../../../services/account/account.service';

declare var $: any;
@Component({
  selector: 'app-account',
  templateUrl: './account.component.html',
  styleUrls: ['./account.component.scss']
})
export class AccountComponent implements OnInit {

  picture:any;
  name:any;
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  urlPictureDefault = avatarDefault;
  constructor(private accountService:AccountService,private store: AngularFireStorage,private toastr: ToastrService, private router: Router,) { }

  ngOnInit(): void {
    $('.link').click(function(){
      $('.link').removeClass('active');
      $(this).addClass('active');
    })
    this.picture = this.urlPictureDefault;
    this.fetchgetInfo();
  }

  fetchgetInfo() {
    this.accountService.getInfo().subscribe(data => {
      this.name = data.data.full_name;
      if (data.data.image === null) {
        this.picture = this.urlPictureDefault;
      } else {
        this.picture = data.data.image;
      }
    }, error => {
    })
  }

  uploadImage(event) {
    let account : accountModel;
    // tslint:disable-next-line:prefer-const
    let file = event.target.files[0];
    // tslint:disable-next-line:prefer-const
    let path = `${file.name}`;
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
            account = {
              email: localStorage.getItem("email"),
              image: url,
            }
            this.accountService.update(account).subscribe(data =>{
              this.toastr.success("Cập nhật ảnh đại diện thành công");
            })
            this.picture = url;
            this.urlPictureDefault = url;
            
          });
        }
        )
      ).subscribe();
    }
  }
  
  onLogout() {
    localStorage.removeItem('Token');
    localStorage.clear();
    this.router.navigate(['/']);
  }
}
