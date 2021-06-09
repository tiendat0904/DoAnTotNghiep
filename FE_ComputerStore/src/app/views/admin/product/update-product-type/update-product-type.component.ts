import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'angular-bootstrap-md';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { productTypeModel } from '../../../../models/product-type-model';
import { ProductTypeService } from '../../../../services/product-type/product-type.service';

@Component({
  selector: 'app-update-product-type',
  templateUrl: './update-product-type.component.html',
  styleUrls: ['./update-product-type.component.scss']
})
export class UpdateProductTypeComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_product_type: Array<productTypeModel>;
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
  model: productTypeModel;
  urlPictureDefault = avatarDefault;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private productTypeService: ProductTypeService,
    private store: AngularFireStorage) { }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharrayListTrademark();
    this.formGroup = new FormGroup({
      product_type_name: new FormControl(),
      description: new FormControl(),
      image: new FormControl()
    });

  }

  fetcharrayListTrademark() {
    this.subscription = this.productTypeService.getAll().subscribe(data => {
      this.arraylist_product_type = data.data;
      this.avatarUrl = data.data.image;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin loại sản phẩm`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin loại sản phẩm`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin loại sản phẩm`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: productTypeModel, type = null): void {
    this.arrCheck = this.arraylist_product_type;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);

    if (model.product_type_id === null || model.product_type_id === undefined) {
      this.formGroup = this.fb.group({
        product_type_name: [null, [Validators.required]],
        description:[null],
        image: [null, [Validators.required]],

      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        product_type_name: [{ value: this.model.product_type_name, disabled: this.isInfo }, [Validators.required]],
        description: [{ value: this.model.description, disabled: this.isInfo }],
        image: '',

      });
      if (this.model.icon === "") {
        this.urlPictureDefault = avatarDefault;
      }
      else {
        this.urlPictureDefault = this.model.icon;
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
    let productType: productTypeModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
    this.toastr.error('Kiểm tra thông tin các trường đã nhập', 'www.tiendatcomputer.vn cho biết');;
      return;
    }
    if (this.isEdit) {
      productType = {
        product_type_id: this.model.product_type_id,
        product_type_name: this.formGroup.get('product_type_name')?.value,
        description: this.formGroup.get('description')?.value,
        icon: this.urlPictureDefault,
      };
    } else {
      productType = {
        product_type_id: this.model.product_type_id,
        product_type_name: this.formGroup.get('product_type_name')?.value,
        description: this.formGroup.get('description')?.value,
        icon: this.urlPictureDefault,
      };
    }
    if (this.isAdd) {
      this.productTypeService.create(productType).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho biết');
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
        }
      );
    }
    if (this.isEdit) {
      this.productTypeService.update(productType.product_type_id, productType).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho biết');
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
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
    let path = `computerstore/productType/${file.name}`;
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
