import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../../environments/environment';
import { trademarkModel } from '../../../../../models/trademark-model';
import { TrademarkService } from '../../../../../services/trademark/trademark.service';

@Component({
  selector: 'app-update-trademark',
  templateUrl: './update-trademark.component.html',
  styleUrls: ['./update-trademark.component.scss']
})
export class UpdateTrademarkComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_trademark: Array<trademarkModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  arrCheck = [];
  closeResult: String;
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  modalReference!: any;
  formGroup: FormGroup;
  subscription: Subscription;
  isAdd = false;
  image: string = null;
  isEdit = false;
  avatarUrl;
  isEditimage = false;
  isInfo = false;
  submitted = false;
  title = '';
  type: any;
  model: trademarkModel;
  urlPictureDefault = avatarDefault;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private trademardService: TrademarkService,
    private store: AngularFireStorage) { }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharrayListTrademark();
    this.formGroup = new FormGroup({
      trademark_name: new FormControl(),
      image: new FormControl()
    });

  }

  fetcharrayListTrademark() {
    this.subscription = this.trademardService.getAll().subscribe(data => {
      this.arraylist_trademark = data.data;
      this.avatarUrl = data.data.image;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin nhãn hiệu`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin nhãn hiệu`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin nhãn hiệu`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: trademarkModel, type = null): void {
    this.arrCheck = this.arraylist_trademark;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);

    if (model.trademark_id === null || model.trademark_id === undefined) {
      this.formGroup = this.fb.group({
        trademark_name: [null, [Validators.required]],
        image: [null, [Validators.required]],

      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        trademark_name: [{ value: this.model.trademark_name, disabled: this.isInfo }, [Validators.required]],
        image: '',

      });
      if (this.model.image === "") {
        this.urlPictureDefault = avatarDefault;
      }
      else {
        this.urlPictureDefault = this.model.image;
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
    let trademark: trademarkModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      trademark = {
        trademark_id: this.model.trademark_id,
        trademark_name: this.formGroup.get('trademark_name')?.value,
        image: this.urlPictureDefault,
      };
    } else {
      trademark = {
        trademark_id: this.model.trademark_id,
        trademark_name: this.formGroup.get('trademark_name')?.value,
        image: this.urlPictureDefault,
      };
    }
    if (this.isAdd) {
      this.trademardService.create(trademark).subscribe(res => {
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
      this.trademardService.update(trademark.trademark_id, trademark).subscribe(res => {
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
    let path = `computerstore/trademark/${file.name}`;
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
