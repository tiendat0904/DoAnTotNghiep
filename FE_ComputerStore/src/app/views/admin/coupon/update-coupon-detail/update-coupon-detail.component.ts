import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { couponDetailModel } from '../../../../models/coupon-detail-model';
import { couponModel } from '../../../../models/coupon-model';
import { productModel } from '../../../../models/product-model';
import { CouponDetailService } from '../../../../services/coupon-detail/coupon-detail.service';
import { CouponService } from '../../../../services/coupon/coupon.service';
import { ProductService } from '../../../../services/product/product.service';


@Component({
  selector: 'app-update-coupon-detail',
  templateUrl: './update-coupon-detail.component.html',
  styleUrls: ['./update-coupon-detail.component.scss']
})
export class UpdateCouponDetailComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_coupon_detail: Array<couponDetailModel>;
  @Input() mess_coupon : couponModel;
  @Input() mess_coupon1 : any;
  @Input() isAdd1 : Boolean;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  listFilterResult: couponDetailModel[] = [];
  listFilterResult1: Array<couponDetailModel> = [];
  arraylist_product: Array<productModel> = [];
  arraylist_coupon: Array<couponModel> = [];
  checkButton = false;
  closeResult: String;
  modalReference!: any;
  formGroup: FormGroup;
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
  update_coupon_id:any;
  model: couponDetailModel;
  dem: number = 0;
  checkNumber : number = 0;
 
  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private couponDetailService: CouponDetailService,
    private productService: ProductService,
    private couponService: CouponService,
    ) {
    }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharraylist_coupon_detail();
    this.fetcharraylist_product();
    this.fetcharraylist_coupon();
  }

  fetcharraylist_coupon_detail(){
    this.arraylist_coupon_detail=[];
    this.couponDetailService.getAll().subscribe(data => {
      this.arraylist_coupon_detail = data.data; 
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_coupon(){
    this.arraylist_coupon=[];
    this.couponService.getAll().subscribe(data => {
      this.arraylist_coupon = data.data;
      if(this.arraylist_coupon.length === 0 ){
        this.update_coupon_id = 1;
      }else{
        this.arraylist_coupon.sort(function (a, b) {
          return a.coupon_id - b.coupon_id;
        });
        this.update_coupon_id = this.arraylist_coupon[this.arraylist_coupon.length-1].coupon_id;
        this.update_coupon_id = this.update_coupon_id+1;
      }
      
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_product(){
    this.arraylist_product=[];
    this.productService.getAll().subscribe(data => {
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
        this.title = `Thêm mới thông tin chi tiết hóa đơn nhập`;
        //  this.update_coupon_id = this.arrCheck.length+1;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin chi tiết hóa đơn nhập`;
        //  this.update_coupon_id = this.model.id;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin chi tiết hóa đơn nhập`;
        //  this.update_coupon_id = this.model.id;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: couponDetailModel, type = null): void {
    this.arrCheck = this.arraylist_coupon_detail;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
   
    if (model.coupon_detail_id === null || model.coupon_detail_id === undefined) {
      if(this.mess_coupon1===undefined){
        console.log(this.update_coupon_id);
        this.formGroup = this.fb.group({
          coupon_id: [ this.update_coupon_id],
          product_id: [ null, [Validators.required]],
          amount: [ null, [Validators.required]],
          price : [ null , [Validators.required]],
  
          
        });
      }else{
        this.formGroup = this.fb.group({
          coupon_id: [ this.mess_coupon1],
          product_id: [ null, [Validators.required]],
          amount: [ null, [Validators.required]],
          price : [ null , [Validators.required]],
  
          
        });
      }
      
    } else {
      this.formGroup = this.fb.group({
        coupon_id: [{value: this.mess_coupon1, disabled: this.isInfo}],
        product_id:[{value: this.model.product_id, disabled: this.isInfo}, [Validators.required]],
        amount:[{value: this.model.amount, disabled: this.isInfo}, [Validators.required]],
        price : [{value: this.model.price, disabled: this.isInfo}, [Validators.required]],
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
    let couponDetail: couponDetailModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    
    if(this.checkNumber === 0 && this.isAdd1===true){
      this.couponService.create(this.mess_coupon).subscribe(res => {
      },
      err => {
        this.toastr.error(err.error.error);
      }
      );
    }
    
    
    if (this.isEdit) {
      couponDetail = {
        coupon_detail_id: this.model.coupon_detail_id,
        coupon_id: this.formGroup.get('coupon_id')?.value,
        product_id: this.formGroup.get('product_id')?.value,
        amount: this.formGroup.get('amount')?.value,
        price : this.formGroup.get('price')?.value,
      };
     
    } else {
      couponDetail = {
        coupon_id: this.formGroup.get('coupon_id')?.value,
        product_id: this.formGroup.get('product_id')?.value,
        amount: this.formGroup.get('amount')?.value,
        price : this.formGroup.get('price')?.value,
      };
    }
    if (this.isAdd) {
      for (let i = 0; i < this.arrCheck.length; i++) {
        if (this.arrCheck[i].coupon_detail_id === couponDetail.coupon_detail_id) {
          check = true;
          break;
        }
      }
      if (check === true) {
        this.toastr.error('Mã nhà cung cấp đã tồn tại');
        return;
      }
      this.couponDetailService.create(couponDetail).subscribe(res => {
        this.closeModalReloadData();
        
        this.listFilterResult=[];
        this.couponDetailService.getAll().subscribe(data => {
          this.arraylist_coupon_detail = data.data;
          for(let item of this.arraylist_coupon_detail){
            if(item.coupon_id===this.mess_coupon1 || item.coupon_id=== this.update_coupon_id){
                this.listFilterResult.push(item);
                this.checkNumber = this.listFilterResult.length;
            }
          }
        },)

        this.toastr.success(res.success);
        this.modalReference.dismiss();
       
      },
      err => {
        this.toastr.error(err.error.error);
      }
      );
    }
    if (this.isEdit) {
      this.couponDetailService.update(couponDetail.coupon_detail_id, couponDetail).subscribe(res => {
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
