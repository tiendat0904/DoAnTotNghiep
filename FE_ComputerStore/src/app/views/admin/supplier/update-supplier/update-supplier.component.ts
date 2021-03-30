import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { supplierModel } from '../../../../models/supplier-model';
import { SupplierService } from '../../../../services/supplier/supplier.service';

@Component({
  selector: 'app-update-supplier',
  templateUrl: './update-supplier.component.html',
  styleUrls: ['./update-supplier.component.scss']
})
export class UpdateSupplierComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_supplier: Array<supplierModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  checkButton = false;
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
  isEditimage=false;
  isInfo = false;
  submitted = false;
  isLoading=false;
  title = '';
  type: any;
  arrCheck = [];
  update_ma_tai_khoan:any;
  model: supplierModel;
  urlPictureDefault = avatarDefault;
 
  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private supplierService: SupplierService,
    private store: AngularFireStorage) {
    }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharraylist_supplier();
    
  }

  fetcharraylist_supplier(){
    this.subscription=this.supplierService.getAll().subscribe(data => {
      this.arraylist_supplier = data.data;
      this.avatarUrl = data.data.hinh_anh;
    },
    err => {
        this.isLoading = false;
      })
  }
  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin nhà cung cấp`;
        // this.update_ma_tai_khoan = this.arrCheck.length+1;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin nhà cung cấp`;
        // this.update_ma_tai_khoan = this.model.supplier_id;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin nhà cung cấp`;
        // this.update_ma_tai_khoan = this.model.supplier_id;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: supplierModel, type = null): void {
    this.arrCheck = this.arraylist_supplier;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
   
    if (model.supplier_id === null || model.supplier_id === undefined) {
      this.formGroup = this.fb.group({
        ten: [ null, [Validators.required]],
        dia_chi: [ null, [Validators.required]],
        hot_line : [ null],
        email: [ null],
        // so_dien_thoai: [ null, [Validators.required]],
        
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        ten: [{value: this.model.supplier_name, disabled: this.isInfo}, [Validators.required]],
        dia_chi: [{value: this.model.supplier_address, disabled: this.isInfo}, [Validators.required]],
        hot_line: [{value: this.model.hotline, disabled: this.isInfo}],
        email: [{value: this.model.email, disabled: this.isInfo}],
        // so_dien_thoai: [{value: this.model., disabled: this.isInfo}, [Validators.required]],
      });
      // if(this.model.image===""){
      //   this.urlPictureDefault = avatarDefault;
      // }
      // else{
      //   this.urlPictureDefault=this.model.hinh_anh;

      // }
      
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
    let nhacungcap: supplierModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      nhacungcap = {
        supplier_id: this.model.supplier_id,
        supplier_name: this.formGroup.get('ten')?.value,
        supplier_address: this.formGroup.get('dia_chi')?.value,
        hotline: this.formGroup.get('hot_line')?.value,
        email: this.formGroup.get('email')?.value,
        // so_dien_thoai: this.formGroup.get('so_dien_thoai')?.value,
        // hinh_anh : this.urlPictureDefault,
      };
     
    } else {
      nhacungcap = {
        supplier_id: this.model.supplier_id,
        supplier_name: this.formGroup.get('ten')?.value,
        supplier_address: this.formGroup.get('dia_chi')?.value,
        hotline: this.formGroup.get('hot_line')?.value,
        email: this.formGroup.get('email')?.value,
        // so_dien_thoai: this.formGroup.get('so_dien_thoai')?.value,
        // hinh_anh : this.urlPictureDefault,
      };
    }
    if (this.isAdd) {
      
      for (let i = 0; i < this.arrCheck.length; i++) {
        if (this.arrCheck[i].supplier_id === nhacungcap.supplier_id) {
          check = true;
          break;
        }
      }
      if (check === true) {
        this.toastr.error('Mã nhà cung cấp đã tồn tại');
        return;
      }
      this.supplierService.create(nhacungcap).subscribe(res => {
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
      this.supplierService.update(nhacungcap.supplier_id, nhacungcap).subscribe(res => {
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
          this.urlPictureDefault=url;
          });
        }
        )
      ).subscribe();
    }
  }

}
