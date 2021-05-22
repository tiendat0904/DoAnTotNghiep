import { DatePipe } from '@angular/common';
import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { newsModel } from '../../../../models/news-model';
import { NewsService } from '../../../../services/news/news.service';

@Component({
  selector: 'app-update-news',
  templateUrl: './update-news.component.html',
  styleUrls: ['./update-news.component.scss']
})
export class UpdateNewsComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_news: Array<newsModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  urlPictureDefault = avatarDefault;
  checkButton = false;
  closeResult: String;
  modalReference!: any;
  formGroup: FormGroup;
  isAdd = false;
  isEdit = false;
  isInfo = false;
  submitted = false;
  title = '';
  type: any;
  model: newsModel;
  arrCheck = [];
  update_id: any;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private newsService: NewsService,
    private store: AngularFireStorage,
    private datePipe: DatePipe) { }

  ngOnInit(): void {
    this.submitted = false;
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin tin tức`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin tin tức`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin tin tức`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: newsModel, type = null): void {
    this.arrCheck = this.arraylist_news;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    if (model.news_id === null || model.news_id === undefined) {
      this.formGroup = this.fb.group({
        title: [null, [Validators.required]],
        news_content: [null, [Validators.required]],
        highlight: [null],
        thumbnail: [null, [Validators.required]],
        url: [null, [Validators.required, Validators.pattern(/^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$/)]],
        created_at: [this.datePipe.transform(Date.now(), "dd/MM/yyyy")],
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        title: [{ value: this.model.title, disabled: this.isInfo }, [Validators.required]],
        news_content: [{ value: this.model.news_content, disabled: this.isInfo }, [Validators.required]],
        highlight: [{ value: this.model.highlight, disabled: this.isInfo }],
        thumbnail: '',
        url: [{ value: this.model.url, disabled: this.isInfo }, [Validators.required, Validators.pattern(/^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$/)]],
        created_at: [{ value: this.model.created_at, disabled: this.isInfo }],
      });
      if (this.model.thumbnail === "") {
        this.urlPictureDefault = avatarDefault;
      } else {
        this.urlPictureDefault = this.model.thumbnail;
      }
    }
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
      centered: true,
      size: 'md',
    });
    this.modalReference.result.then(
      (result: any) => {
        this.closeResult = `Closed with: ${result}`;
      },
      (reason: any) => {
        this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
      }
    );
  }

  private getDismissReason(reason: any): string {
    if (reason === ModalDismissReasons.ESC) {
      return 'by pressing ESC';
    } else if (reason === ModalDismissReasons.BACKDROP_CLICK) {
      return 'by clicking on a backdrop';
    } else {
      return `with: ${reason}`;
    }
  }

  save() {
    let check = false;
    let news: newsModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      news = {
        news_id: this.model.news_id,
        title: this.formGroup.get('title')?.value,
        news_content: this.formGroup.get('news_content')?.value,
        highlight: this.formGroup.get('highlight')?.value,
        thumbnail: this.urlPictureDefault,
        url: this.formGroup.get('url')?.value,
        created_at: this.formGroup.get('created_at')?.value,
      };
    } else {
      news = {
        title: this.formGroup.get('title')?.value,
        news_content: this.formGroup.get('news_content')?.value,
        highlight: this.formGroup.get('highlight')?.value,
        thumbnail: this.urlPictureDefault,
        url: this.formGroup.get('url')?.value,
        created_at: this.formGroup.get('created_at')?.value,
      };
    }
    if (this.isAdd) {
      this.newsService.create(news).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success);
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error);
        }
      );
    }
    if (this.isEdit) {
      this.newsService.update(news.news_id, news).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success);
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error);
        }
      );
    }
  }

  public closeModalReloadData(): void {
    this.submitted = false;
    this.eventEmit.emit('success');
  }

  uploadImage(event) {
    let file = event.target.files[0];
    let path = `thuonghieu/${file.name}`;
    if (file.type.split('/')[0] !== 'image') {
      return alert('Erreur, ce fichier n\'est pas une image');
    } else {
      let ref = this.store.ref(path);
      let task = this.store.upload(path, file);
      this.uploadPercent = task.percentageChanges();
      task.snapshotChanges().pipe(
        finalize(() => {
          this.downloadURL = ref.getDownloadURL();
          this.downloadURL.subscribe(url => {
            this.urlPictureDefault = url;
          });
        }
        )
      ).subscribe();
    }
  }

}
