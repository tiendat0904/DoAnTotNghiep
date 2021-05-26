import { DatePipe } from '@angular/common';
import { Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { accountModel } from '../../../../models/account-model';
import { couponDetailModel } from '../../../../models/coupon-detail-model';
import { couponModel } from '../../../../models/coupon-model';
import { supplierModel } from '../../../../models/supplier-model';
import { AccountService } from '../../../../services/account/account.service';
import { CouponDetailService } from '../../../../services/coupon-detail/coupon-detail.service';
import { CouponService } from '../../../../services/coupon/coupon.service';
import { SupplierService } from '../../../../services/supplier/supplier.service';
import { UpdateCouponDetailComponent } from '../update-coupon-detail/update-coupon-detail.component';

@Component({
  selector: 'app-create-coupon',
  templateUrl: './create-coupon.component.html',
  styleUrls: ['./create-coupon.component.scss']
})
export class CreateCouponComponent implements OnInit, OnDestroy {

  @ViewChild(UpdateCouponDetailComponent) view!: UpdateCouponDetailComponent;
  arraylist_coupon_detail: Array<couponDetailModel> = [];
  // arraylist_employee_filter: Array<accountModel> = [];
  arraylist_supplier: Array<supplierModel> = [];
  arraylist_coupon: Array<couponModel> = [];
  arraylist_employee: Array<accountModel> = [];
  listFilterResult: couponDetailModel[] = [];
  filterResultTemplist: couponDetailModel[] = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  update_total_money = 0.00;
  submitted = false;
  formGroup: FormGroup;
  searchedKeyword: string;
  update_coupon_id: any;
  isAdd: Boolean;
  page = 1;
  pageSize = 5;
  isCheckhdn = true;
  isCheckhdn1 = false;
  isButtonSave = false;
  // coupon_id: any;
  update_employee_id = null;
  update_supplier_id = null;
  update_coupon_code = null;
  coupon: couponModel;

  constructor(
    private modalService: NgbModal,
    private couponDetailService: CouponDetailService,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private router: Router,
    private accountService: AccountService,
    private supplierService: SupplierService,
    private couponService: CouponService,
    private datePipe: DatePipe,
    public loaderService: LoaderService
  ) {
    this.formGroup = this.fb.group({
      employee_id: [null, [Validators.required]],
      supplier_id: [null, [Validators.required]],
      coupon_code: [null, [Validators.required]],
      created_at: [this.datePipe.transform(Date.now(), "dd/MM/yyyy")],
      total_money: [this.update_total_money],
    });
  }

  ngOnDestroy(): void {
    this.searchedKeyword = '';
    localStorage.removeItem("coupon_id");
  }

  ngOnInit(): void {
    setTimeout(() => {
      this.update_coupon_id = Number(localStorage.getItem("coupon_id"));
      this.update_employee_id = localStorage.getItem("account_id");
      this.isAdd = true;
      this.submitted = false;
      this.update_total_money = 0;
      this.fetchListEmployee();
      this.fetchListSupplier();
      console.log(this.arraylist_coupon_detail.length);
      this.couponService.detail(this.update_coupon_id).subscribe(data => {
        this.arraylist_coupon = data.data;
        if (data.data === undefined) {
        } else {
          if (data.data.coupon_id === undefined || data.data.coupon_id === null) {
          }
          else {
            this.update_supplier_id = data.data.supplier_id;
            this.update_employee_id = data.data.employee_id;
            this.update_coupon_code = data.data.coupon_code;
          }
        }
      })
      this.arraylist_coupon_detail = this.listFilterResult;
      for(let item of this.listFilterResult){
        this.update_total_money += item.amount * item.price;
      }
      
    },500);
  }

  save() {
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    this.isButtonSave = true;
    this.isCheckhdn = false;
    this.isCheckhdn1 = true;
  }

  saveCoupon(){
    if(this.arraylist_coupon_detail.length === 0){
      this.toastr.error("Phiếu nhập trống, vui lòng thêm chi tiết sản phẩm");
    }
    else{
      this.coupon = {
        employee_id: this.formGroup.get('employee_id')?.value,
        supplier_id: this.formGroup.get('supplier_id')?.value,
        coupon_code : this.formGroup.get('coupon_code')?.value,
        listCouponDetail:this.arraylist_coupon_detail
      };
      this.couponService.create(this.coupon).subscribe(data =>{
        this.toastr.success(data.success);
        this.getNavigation('admin/coupon');
      }
      );
    }
  }


  fetchListEmployee() {
    this.arraylist_employee = [];
    this.accountService.getAccountOfEmployee().subscribe(data => {
      this.arraylist_employee = data.data;
    })
  }

  fetchListSupplier() {
    this.arraylist_supplier = [];
    this.supplierService.getAll().subscribe(data => {
      this.arraylist_supplier = data.data;
    })
  }


  addItem(newItem: couponDetailModel) {
    this.listFilterResult.push(newItem);
  }

  deleteCoupon_Detail(product_name :any){
    this.listFilterResult.forEach((element,index)=>{
      if(element.product_name === product_name) this.listFilterResult.splice(index,1);
   });
   this.modalReference.dismiss();
  }

  public filterByKeyword() {
    var filterResult = [];
    if (this.searchedKeyword.length == 0) {
      this.listFilterResult = this.filterResultTemplist;
    } else {
      this.listFilterResult = this.filterResultTemplist;
      var keyword = this.searchedKeyword.toLowerCase();
      this.listFilterResult.forEach(item => {
        var dc = item.product_name.toLowerCase();
        var hot_line = item.price.toString();
        var ten = item.price.toString();
        if (hot_line.includes(keyword) || ten.includes(keyword) || dc.includes(keyword)) {
          filterResult.push(item);
        }
      });
      this.listFilterResult = filterResult;
    }
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
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

  checkAllCheckBox(ev) {
    this.listFilterResult.forEach((x) => (x.checked = ev.target.checked));
    this.changeModel();
  }

  isAllCheckBoxChecked() {
    return this.listFilterResult.every((p) => p.checked);
  }

  changeModel() {
    const selectedHometowns = this.listFilterResult
      .filter((couponDetail) => couponDetail.checked)
      .map((p) => p.product_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  getNavigation(link) {
    if (this.listFilterResult.length === 0) {
      this.router.navigate([link]);
    } else {
      this.router.navigate([link]);
    }
  }

  // deleteCouponDetail(item: any = null) {
  //   let selectedcouponDetail = [];
  //   if (item !== null && item !== undefined && item !== '') {
  //     selectedcouponDetail.push(item);
  //     this.delete(selectedcouponDetail);
  //     return;
  //   }
  //   selectedcouponDetail = this.listFilterResult
  //     .filter((couponDetail) => couponDetail.checked)
  //     .map((p) => p.product_id);
  //   if (selectedcouponDetail.length === 0) {
  //     this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
  //     return;
  //   }
  //   this.delete(selectedcouponDetail);
  // }

  initModal(model: any, type = null): void {
    this.view.view(model, type);
  }

  // public delete(listid: any) {
  //   const modelDelete = {
  //     listId: listid
  //   };
  //   for (var i = 0; i < this.listFilterResult.length; i++) {
  //     if (this.listFilterResult[i].checked == true) {
  //       this.listFilterResult[i].checked = false;
  //     }
  //   }
  //   this.searchedKeyword = null;
  //   this.filterResultTemplist = this.listFilterResult;
  //   for (var i = 0; i < this.listFilterResult.length; i++) {
  //     if (this.listFilterResult[i].checked == true) {
  //       this.listFilterResult[i].checked = false;
  //     }
  //   }
  //   this.searchedKeyword = null;
  //   this.filterResultTemplist = this.listFilterResult;
  //   this.couponDetailService.delete(modelDelete).subscribe(
  //     (result) => {
  //       this.ngOnInit();
  //       this.changeModel();
  //       if (result.error) {
  //         this.toastr.error(result.error);
  //       } else {
  //         this.toastr.success(result.success);
  //       }
  //       this.modalReference.dismiss();
  //     },
  //   );
  // }

}
