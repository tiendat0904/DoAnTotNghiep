import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { productModel } from '../../../../models/product-model';
import { productTypeModel } from '../../../../models/product-type-model';
import { trademarkModel } from '../../../../models/trademark-model';
import { ProductTypeService } from '../../../../services/product-type/product-type.service';
import { ProductService } from '../../../../services/product/product.service';
import { TrademarkService } from '../../../../services/trademark/trademark.service';

@Component({
  selector: 'app-update-product',
  templateUrl: './update-product.component.html',
  styleUrls: ['./update-product.component.scss']
})
export class UpdateProductComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_product: Array<productModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  arraylist_trademark: Array<trademarkModel> = [];
  arraylist_product_type: Array<productTypeModel> = [];
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
  model: productModel;
  urlPictureDefault = avatarDefault;
 
  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private productService: ProductService,
    private trademarkService: TrademarkService,
    private productTypeService: ProductTypeService,
    private store: AngularFireStorage) {
    }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharraylist_product();
    this.fetcharraylist_product_type();
    this.fetcharraylist_trademark();
    
  }

  fetcharraylist_trademark(){
    this.subscription=this.trademarkService.getAll().subscribe(data => {
      this.arraylist_trademark = data.data;
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_product_type(){
    this.subscription=this.productTypeService.getAll().subscribe(data => {
      this.arraylist_product_type = data.data;
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_product(){
    this.subscription=this.productService.getAll().subscribe(data => {
      this.arraylist_product = data.data;
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
        this.title = `Thêm mới thông tin sản phẩm`;
        // this.update_ma_tai_khoan = this.arrCheck.length+1;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin sản phẩm`;
        // this.update_ma_tai_khoan = this.model.product_id;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin sản phẩm`;
        // this.update_ma_tai_khoan = this.model.product_id;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: productModel, type = null): void {
    this.arrCheck = this.arraylist_product;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
   
    if (model.product_id === null || model.product_id === undefined) {
      this.formGroup = this.fb.group({
        product_name: [ null, [Validators.required]],
        trademark_id: [ null,[Validators.required]],
        product_type_id: [ null,[Validators.required]],
        description:[ null,[Validators.required]],
        // so_dien_thoai: [ null, [Validators.required]],
        
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        product_name: [{value: this.model.product_name, disabled: this.isInfo}, [Validators.required]],
        trademark_id :[{value: this.model.trademark_id, disabled: this.isInfo}, [Validators.required]],
        product_type_id :[{value: this.model.product_type_id, disabled: this.isInfo}, [Validators.required]],
        description:[{value: this.model.description, disabled: this.isInfo}, [Validators.required]],
        // image: [{value: this.model.image, disabled: this.isInfo},[Validators.required]],
        // dia_chi: [{value: this.model.supplier_address, disabled: this.isInfo}, [Validators.required]],
        // hot_line: [{value: this.model.hotline, disabled: this.isInfo}],
        // email: [{value: this.model.email, disabled: this.isInfo}],
        // so_dien_thoai: [{value: this.model., disabled: this.isInfo}, [Validators.required]],
      });
      // if(this.model.image===""){
      //   this.urlPictureDefault = avatarDefault;
      // }
      // else{
      //   this.urlPictureDefault=this.model.image;

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
    let product: productModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      product = {
        product_id: this.model.product_id,
        product_name: this.formGroup.get('product_name')?.value,
        trademark_id: this.formGroup.get('trademark_id')?.value,
        product_type_id: this.formGroup.get('product_type_id')?.value,
        description : this.formGroup.get('description')?.value
        // supplier_address: this.formGroup.get('dia_chi')?.value,
        // hotline: this.formGroup.get('hot_line')?.value,
        // email: this.formGroup.get('email')?.value,
        // so_dien_thoai: this.formGroup.get('so_dien_thoai')?.value,
        // image : this.urlPictureDefault,
      };
     
    } else {
      product = {
        product_id: this.model.product_id,
        product_name: this.formGroup.get('product_name')?.value,
        trademark_id: this.formGroup.get('trademark_id')?.value,
        product_type_id: this.formGroup.get('product_type_id')?.value,
        description : this.formGroup.get('description')?.value
        // so_dien_thoai: this.formGroup.get('so_dien_thoai')?.value,
        // image : this.urlPictureDefault,
      };
    }
    if (this.isAdd) {
      
      // for (let i = 0; i < this.arrCheck.length; i++) {
      //   if (this.arrCheck[i].product_id === product.product_id) {
      //     check = true;
      //     break;
      //   }
      // }
      // if (check === true) {
      //   this.toastr.error('Mã sản phẩm đã tồn tại');
      //   return;
      // }
      this.productService.create(product).subscribe(res => {
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
      this.productService.update(product.product_id, product).subscribe(res => {
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
