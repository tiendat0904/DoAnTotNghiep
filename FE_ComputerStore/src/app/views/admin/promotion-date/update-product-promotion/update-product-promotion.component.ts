import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { avatarDefault } from '../../../../../environments/environment';
import { productModel } from '../../../../models/product-model';
import { productPromotionDModel } from '../../../../models/product-promotion-model';
import { ProductPromotionService } from '../../../../services/product-promotion/product-promotion.service';
import { ProductService } from '../../../../services/product/product.service';
import { PromotionDateService } from '../../../../services/promotion-date/promotion-date.service';

@Component({
  selector: 'app-update-product-promotion',
  templateUrl: './update-product-promotion.component.html',
  styleUrls: ['./update-product-promotion.component.scss']
})
export class UpdateProductPromotionComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_product_promotion: Array<productPromotionDModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  arraylist_product: Array<productModel> = [];
  arraylist_promotion_date: Array<productPromotionDModel> = [];
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
  arrCheck = [];
  update_ma_tai_khoan: any;
  model: productPromotionDModel;
  urlPictureDefault = avatarDefault;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private productPromotionService: ProductPromotionService,
    private productService: ProductService,
    private promotionDateService: PromotionDateService) {
  }

  ngOnInit(): void {
    this.submitted = false;
    this.fetchListProduct();
    this.fetchListProductPromotion();
    this.fetchListPromotionDate();
  }

  fetchListProduct() {
    this.productService.getAll().subscribe(data => {
      this.arraylist_product = data.data;
    })
  }

  fetchListProductPromotion() {
    this.subscription = this.productPromotionService.getAll().subscribe(data => {
      this.arraylist_product_promotion = data.data;
    })
  }

  fetchListPromotionDate() {
    this.arraylist_promotion_date = [];
    this.subscription = this.promotionDateService.getAll().subscribe(data => {
      this.arraylist_promotion_date = data.data;
    })
  }
  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin khuyến mãi sản phẩm`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin khuyến mãi sản phẩm`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin khuyến mãi sản phẩm`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: productPromotionDModel, type = null): void {
    this.arrCheck = this.arraylist_product_promotion;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    if (model.promotion_date_id === null || model.promotion_date_id === undefined) {
      this.formGroup = this.fb.group({
        product_id: [null, [Validators.required]],
        promotion_date_id: [null, [Validators.required]],
        promotion_level: [null, [Validators.required]],
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        product_id: [{ value: this.model.product_id, disabled: this.isInfo }, [Validators.required]],
        promotion_date_id: [{ value: this.model.promotion_date_id, disabled: this.isInfo }, [Validators.required]],
        promotion_level: [{ value: this.model.promotion_level, disabled: this.isInfo }, [Validators.required]],
      });
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
    let promotion_date: productPromotionDModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      promotion_date = {
        product_promotion_id: this.model.product_promotion_id,
        product_id: this.formGroup.get('product_id')?.value,
        promotion_date_id: this.formGroup.get('promotion_date_id')?.value,
        promotion_level: this.formGroup.get('promotion_level')?.value,
      };

    } else {
      promotion_date = {
        product_id: this.formGroup.get('product_id')?.value,
        promotion_date_id: this.formGroup.get('promotion_date_id')?.value,
        promotion_level: this.formGroup.get('promotion_level')?.value,
      };
    }
    if (this.isAdd) {
      this.productPromotionService.create(promotion_date).subscribe(res => {
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
      console.log(promotion_date);
      this.productPromotionService.update(promotion_date.product_promotion_id, promotion_date).subscribe(res => {
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

}
