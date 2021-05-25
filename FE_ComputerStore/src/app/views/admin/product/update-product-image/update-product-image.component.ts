import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { productImageModel } from '../../../../models/product-image-model';
import { productModel } from '../../../../models/product-model';
import { ProductImageService } from '../../../../services/product-image/product-image.service';
import { ProductService } from '../../../../services/product/product.service';

@Component({
  selector: 'app-update-product-image',
  templateUrl: './update-product-image.component.html',
  styleUrls: ['./update-product-image.component.scss']
})
export class UpdateProductImageComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_product_image: Array<productImageModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  arraylist_product: Array<productModel> = [];
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
  isEditimage = false;
  isInfo = false;
  submitted = false;
  isLoading = false;
  title = '';
  type: any;
  arrCheck = [];
  uploads: any[];
  update_ma_tai_khoan: any;
  model: productImageModel;
  urlPictureDefault = avatarDefault;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private productService: ProductService,
    private productImageService: ProductImageService,
    private store: AngularFireStorage) { }

  ngOnInit(): void {
    this.submitted = false;
    this.fetchListProductImage();
    this.uploads = [];
  }

  fetchListProductImage() {
    this.subscription = this.productService.getAll().subscribe(data => {
      this.arraylist_product = data.data;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin hình ảnh sản phẩm`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin hình ảnh sản phẩm`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin hình ảnh sản phẩm`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: productImageModel, type = null): void {
    this.arrCheck = this.arraylist_product_image;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    this.uploads = [];

    if (model.product_id === null || model.product_id === undefined) {
      this.formGroup = this.fb.group({
        product_id: [null, [Validators.required]],
        image: [null, [Validators.required]],
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        product_id: [{ value: this.model.product_id, disabled: this.isInfo }, [Validators.required]],
        image: '',
      });
      console.log(this.model.image);
      if (this.model.image.length === 0) {
        this.urlPictureDefault = avatarDefault;
      } else {
        this.urlPictureDefault = this.model.image
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
    let product: productImageModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      product = {
        product_id: this.model.product_id,
        image: this.uploads,
      };
    } else {
      product = {
        product_id: this.formGroup.get('product_id')?.value,
        image: this.uploads,
      };
    }
    if (this.isAdd) {
      this.productImageService.create(product).subscribe(res => {
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
      this.productImageService.update(product).subscribe(res => {
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
    this.uploads = [];
    const filelist = event.target.files;
    for (const file of filelist) {
      let path = `computerstore/product/${file.name}`;
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
              this.uploads.push(url);
              this.urlPictureDefault = this.uploads[0];
            });
          }
          )
        ).subscribe();
      }

    }

  }

}
