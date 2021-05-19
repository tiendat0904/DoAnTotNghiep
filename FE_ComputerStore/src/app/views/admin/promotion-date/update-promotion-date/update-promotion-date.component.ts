import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { avatarDefault } from '../../../../../environments/environment';
import { productModel } from '../../../../models/product-model';
import { promotionDateModel } from '../../../../models/promotion-date-model';
import { ProductService } from '../../../../services/product/product.service';
import { PromotionDateService } from '../../../../services/promotion-date/promotion-date.service';

@Component({
  selector: 'app-update-promotion-date',
  templateUrl: './update-promotion-date.component.html',
  styleUrls: ['./update-promotion-date.component.scss']
})
export class UpdatePromotionDateComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_promotion_date: Array<promotionDateModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  list_product: Array<productModel> = [];
  list_product_filter: Array<productModel> = [];
  filterResultTemplist: productModel[] = [];
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
  model: promotionDateModel;
  urlPictureDefault = avatarDefault;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;
  checkedProduct:boolean;
 
  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private productService:ProductService,
    private promotionDateService: PromotionDateService,
    private store: AngularFireStorage) {
    }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharraylist_promotion_date();
    this.fetcharraylistproduct();
  }

  fetcharraylistproduct(){
    this.searchedKeyword = null;
    this.subscription=this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product.forEach((x) => (x.checked = false));
      this.checkedProduct = true;
      this.filterResultTemplist = this.list_product;
    },
    err => {
        this.isLoading = false;
      })
  }
  

  fetcharraylist_promotion_date(){
    this.formGroup = new FormGroup({
      date: new FormControl(),
      promotion_level: new FormControl()
    });
    this.subscription=this.promotionDateService.getAll().subscribe(data => {
      this.arraylist_promotion_date = data.data;
    },
    err => {
        this.isLoading = false;
      })
  }

  public filterByKeyword() {
    var filterResult = [];
    if (this.searchedKeyword.length == 0) {
      this.list_product =  this.filterResultTemplist;
    } else {
      this.list_product =  this.filterResultTemplist;
      var keyword = this.searchedKeyword.toLowerCase();
      this.list_product.forEach(item => {
        var name = item.product_name.toLowerCase();
        var trademark = item.trademark_name.toLowerCase();
        var product_type_name = item.product_type_name.toLowerCase();
        if (name.includes(keyword) || trademark.includes(keyword) || product_type_name.includes(keyword)) {
          filterResult.push(item);
        }
      });
      this.list_product = filterResult;
    }
  }

  checkAllCheckBox(ev) {
    this.list_product.forEach((x) => (x.checked = ev.target.checked));
    this.changeModel();
  }

  isAllCheckBoxChecked() {
    return this.list_product.every((p) => p.checked);
  }

  changeModel() {
    const selectedHometowns = this.list_product
      .filter((product) => product.checked)
      .map((p) => p.product_id);
      if (selectedHometowns.length > 0) {
        this.checkedProduct = false;
  
      } else {
        this.checkedProduct = true;
      }
  }

  resetProduct(){
    this.list_product.forEach((x) => (x.checked = false));
    this.checkedProduct = true;
  }


  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin ngày khuyến mãi`;
        // this.update_ma_tai_khoan = this.arrCheck.length+1;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin ngày khuyến mãi`;
        // this.update_ma_tai_khoan = this.model.promotion_date_id;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin ngày khuyến mãi`;
        // this.update_ma_tai_khoan = this.model.promotion_date_id;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: promotionDateModel, type = null): void {
    this.arrCheck = this.arraylist_promotion_date;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
   
    if (model.promotion_date_id === null || model.promotion_date_id === undefined) {
      this.formGroup = this.fb.group({
        date: [ null, [Validators.required]],
        promotion_level: [ null, [Validators.required]],
        
      });
      for (var i = 0; i < this.list_product.length; i++) {
        if (this.list_product[i].checked == true) {
          this.list_product[i].checked = false;
        }
      }
      this.searchedKeyword = null;
      this.checkedProduct = true;
      this.filterResultTemplist = this.list_product;
    } else {
      this.formGroup = this.fb.group({
        date: [{value: this.model.date, disabled: this.isInfo}, [Validators.required]],
        promotion_level: [{value:this.model.promotion_level, disabled: this.isInfo}, [Validators.required]],
      });     
    }
  }


  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
      centered: true,
      size: <any>'xl',
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
    let promotion_date: promotionDateModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      // promotion_date = {
      //   promotion_date_id: this.model.promotion_date_id,
      //   date: this.formGroup.get('date')?.value,
      //   promotion_level: this.formGroup.get('promotion_level').value
      // };
     
    } else {
      
      this.list_product_filter = this.filterResultTemplist.filter(product => product.checked === true);
      promotion_date = {
        date: this.formGroup.get('date')?.value,
        promotion_level: this.formGroup.get('promotion_level').value,
        listProduct:this.list_product_filter
      };
    }
    if (this.isAdd) {
      if(this.list_product_filter.length !== 0){
        this.promotionDateService.create(promotion_date).subscribe(res => {
          for (var i = 0; i < this.list_product.length; i++) {
            if (this.list_product[i].checked == true) {
              this.list_product[i].checked = false;
            }
          }
          this.searchedKeyword = null;
          this.filterResultTemplist = this.list_product;
          this.closeModalReloadData();
          this.toastr.success(res.success);
          this.modalReference.dismiss();
        },
        err => {
          this.toastr.error(err.error.error);
        }
        );
      }else{
        this.toastr.warning("Vui lòng chọn sản phẩm khuyến mãi!!!");
      }
    }
    if (this.isEdit) {
      this.promotionDateService.update(promotion_date.promotion_date_id, promotion_date).subscribe(res => {
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
