import { ChangeDetectionStrategy, Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
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
  selector: 'app-update-coupon',
  templateUrl: './update-coupon.component.html',
  styleUrls: ['./update-coupon.component.scss'],
})
export class UpdateCouponComponent implements OnInit {

  @ViewChild(UpdateCouponDetailComponent) view!: UpdateCouponDetailComponent;
  arraylist_coupon_detail: Array<couponDetailModel> = [];
  arraylist_supplier: Array<supplierModel> = [];
  arraylist_coupon: Array<couponModel> = [];
  arraylist_employee: Array<accountModel> = [];
  arraylist_employee_filter: Array<accountModel> = [];
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
  page = 1;
  pageSize = 5;
  isCheckhdn = true;
  isCheckhdn1 = false;
  coupon_id: any;
  update_employee_id = null;
  update_supplier_id = null;
  update_created_at = null;
  update_coupon_code = null;

  constructor(
    private modalService: NgbModal,
    private couponDetailService: CouponDetailService,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private router: Router,
    private accountService: AccountService,
    private supplierService: SupplierService,
    private actRoute: ActivatedRoute,
    private couponService: CouponService,
    public loaderService: LoaderService

  ) {
    this.couponService.getAll().subscribe(data => {
      this.arraylist_coupon = data.data;
      // this.update_coupon_id = this.arraylist_coupon.length+1;
    })
  }
  ngOnInit(): void {
    this.searchedKeyword ='';
    this.submitted = false;
    this.fetchListEmployee();
    this.fetchListSupplier();
    this.fetchListCouponDetail();
    this.update_coupon_id = this.actRoute.snapshot.params['id'];
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
          this.update_total_money = data.data.total_money;
          this.update_created_at = data.data.created_at;
        }
      }
    })

    this.formGroup = this.fb.group({
      coupon_id: [this.update_coupon_id],
      coupon_code:[this.update_coupon_code],
      employee_id: [this.update_employee_id],
      supplier_id: [this.update_supplier_id],
      created_at: [this.update_created_at],
      total_money: [this.update_total_money],
    });
  }

  save() {
    let coupon: couponModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập', "www.tiendatcomputer.vn cho biết");
      return;
    }
    coupon = {
      coupon_code : this.formGroup.get('coupon_code')?.value,
      employee_id: this.formGroup.get('employee_id')?.value,
      supplier_id: this.formGroup.get('supplier_id')?.value,
    };

    this.couponService.update(this.update_coupon_id, coupon).subscribe(res => {
      this.toastr.success(res.success, "www.tiendatcomputer.vn cho biết");
      this.isCheckhdn = false;
      this.isCheckhdn1 = true;
      this.getNavigation('admin/coupon','');
    },
      err => {
        this.toastr.error(err.error.error, "www.tiendatcomputer.vn cho biết");
      }
    );
  }

  // fetcharraylist_coupon(){
  //   this.arraylist_coupon=[];
  //   this.isLoading =  true;
  //   this.couponService.getAll().subscribe(data => {
  //     this.arraylist_coupon = data.data;
  //     //this.update_coupon_id = this.arraylist_coupon.length+1;
  //   },
  //   err => {
  //       this.isLoading = false;
  //     })
  // }

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

  fetchListCouponDetail() {
    this.listFilterResult = [];
    this.couponDetailService.getAll().subscribe(data => {
      this.arraylist_coupon_detail = data.data;
      for (let item of this.arraylist_coupon_detail) {
        if (item.coupon_id == this.update_coupon_id) {
          this.listFilterResult.push(item);
        }
      }
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;
    })
  }

  public filterByKeyword() {
    var filterResult = [];
    if (this.searchedKeyword.length == 0) {
      this.listFilterResult = this.filterResultTemplist;
    } else {
      this.listFilterResult = this.filterResultTemplist;
      var keyword = this.searchedKeyword.toLowerCase();
      this.listFilterResult.forEach(item => {
        var dc = item.amount.toString();
        var hot_line = item.product_name.toLowerCase();
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

  getNavigation(link, id) {
    if (id === '') {
      this.router.navigate([link]);
    } else {
      this.router.navigate([link + '/' + id]);
    }
  }

  deleteCouponDetail(item: any = null,product_id:any) {
    let selectedthongtincd = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedthongtincd.push(item);
      this.delete(selectedthongtincd,product_id);
      return;
    }
    
    selectedthongtincd = this.listFilterResult
      .filter((thongtincd) => thongtincd.checked)
      .map((p) => p.coupon_id);
    if (selectedthongtincd.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.', "www.tiendatcomputer.vn cho biết");
      return;
    }
    this.delete(selectedthongtincd);
  }

  initModal(model: any, type = null): void {
    this.view.view(model, type);
  }

  public delete(listid: any, product_id = null) {
    const modelDelete = {
      listId: listid,
      product_id:product_id
    };
    for (var i = 0; i < this.listFilterResult.length; i++) {
      if (this.listFilterResult[i].checked == true) {
        this.listFilterResult[i].checked = false;
      }
    }
    this.searchedKeyword = null;
    this.filterResultTemplist = this.listFilterResult;
    for (var i = 0; i < this.listFilterResult.length; i++) {
      if (this.listFilterResult[i].checked == true) {
        this.listFilterResult[i].checked = false;
      }
    }
    this.searchedKeyword = null;
    this.filterResultTemplist = this.listFilterResult;
    this.couponDetailService.delete(modelDelete).subscribe(
      (result) => {
        this.ngOnInit();
        this.changeModel();
        this.toastr.success(result.success, "www.tiendatcomputer.vn cho biết");
        // if (result.error) {
        //   this.toastr.error(result.error, "www.tiendatcomputer.vn cho biết");
        // } else {
        //   this.toastr.success(result.success, "www.tiendatcomputer.vn cho biết");
        // }
        this.modalReference.dismiss();
      },err =>{
        this.toastr.error(err.error.error, "www.tiendatcomputer.vn cho biết");
        this.modalReference.dismiss();
      }
    );
  }

}
