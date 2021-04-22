import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
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
  styleUrls: ['./update-coupon.component.scss']
})
export class UpdateCouponComponent implements OnInit {

  @ViewChild(UpdateCouponDetailComponent) view!: UpdateCouponDetailComponent;
  arraylist_coupon_detail: Array<couponDetailModel> = [];
  arraylist_supplier: Array<supplierModel> = [];
  arraylist_coupon: Array<couponModel> = [];
  arraylist_employee: Array<accountModel> = [];
  arraylist_employee_filter: Array<accountModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  update_total_money = 0.00;
  submitted = false;
  formGroup: FormGroup;
  searchedKeyword: string;
  update_coupon_id: any;
  listFilterResult: couponDetailModel[] = [];
  listFilterResult1: Array<couponDetailModel> = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: couponDetailModel[] = [];
  isCheckhdn = true;
  isCheckhdn1 = false;
  coupon_id: any;
  update_employee_id= null;
  update_supplier_id= null;
  update_created_at= null;
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

    ) {
      this.couponService.getAll().subscribe(data => {
        this.arraylist_coupon = data.data;
        // this.update_coupon_id = this.arraylist_coupon.length+1;
      },)
      
     
      
     
    }

  
  ngOnInit(): void {
    
    this.submitted = false;
    this.fetcharraylist_employee();
    this.fetcharraylist_supplier();
    this.update_coupon_id = this.actRoute.snapshot.params['id'];
    this.couponService.detail(this.update_coupon_id).subscribe(data => {
      this.arraylist_coupon = data.data;
      if(data.data === undefined){
      }else{
        if(data.data.coupon_id === undefined || data.data.coupon_id === null){
          
        }
        else{
          
          this.update_supplier_id = data.data.supplier_id;
          this.update_employee_id = data.data.employee_id;
          this.update_total_money = data.data.total_money;
          this.update_created_at = data.data.created_at;
        }
      }
      
      
    },)

    this.formGroup = this.fb.group({
      coupon_id: [this.update_coupon_id],
      employee_id: [this.update_employee_id],
      supplier_id:[ this.update_supplier_id],
      created_at: [this.update_created_at],
      total_money:[this.update_total_money ],
    });
    this.fetcharraylist_coupon_detail();
    
  }

  save() {
    let check = false;
    let coupon: couponModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    coupon = {
      employee_id: this.formGroup.get('employee_id')?.value,
      supplier_id: this.formGroup.get('supplier_id')?.value,
     
    };

    this.couponService.update(this.update_coupon_id,coupon).subscribe(res => {
      this.toastr.success(res.success);    
      this.isCheckhdn = false;
      this.isCheckhdn1 = true;
      
    },
    err => {
      this.toastr.error(err.error.error);
    }
    );
  } 

  fetcharraylist_coupon(){
    this.arraylist_coupon=[];
    this.isLoading =  true;
    this.couponService.getAll().subscribe(data => {
      this.arraylist_coupon = data.data;
      //this.update_coupon_id = this.arraylist_coupon.length+1;
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_employee(){
    this.arraylist_employee=[];
    this.isLoading =  true;
    this.accountService.getAll().subscribe(data => {
      this.arraylist_employee = data.data;
      this.arraylist_employee_filter = this.arraylist_employee.filter(employee => employee.value==="NV" || employee.value==="AD");
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_supplier(){
    this.arraylist_supplier=[];
    this.isLoading =  true;
    this.supplierService.getAll().subscribe(data => {
      this.arraylist_supplier = data.data;
    },
    err => {
        this.isLoading = false;
      })
  }
  

  fetcharraylist_coupon_detail() { 
    this.listFilterResult=[];
    this.listFilterResult1 =[];
    this.isLoading = true;
    this.couponDetailService.getAll().subscribe(data => {
      this.arraylist_coupon_detail = data.data;
      for(let item of this.arraylist_coupon_detail){
        if(item.coupon_id==this.update_coupon_id){
            this.listFilterResult.push(item);
            this.listFilterResult1.push(item);
        }
      }
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;
    },
      err => {
        this.isLoading = false;
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

  getNavigation(link, id){
    if(id === ''){
        this.router.navigate([link]);
    } else {
        this.router.navigate([link + '/' + id]);
    }
  }

  delete_coupon_detail(item: any = null) {
    let selectedthongtincd= [];
    if (item !== null && item !== undefined && item !== '') {
      selectedthongtincd.push(item);
      this.delete(selectedthongtincd);
      return;
    }
    selectedthongtincd = this.listFilterResult
      .filter((thongtincd) => thongtincd.checked)
      .map((p) => p.coupon_id);
    if (selectedthongtincd.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedthongtincd);
  }

  initModal(model: any,type = null): void {
    this.view.view(model, type);
  }

  changeStatus(event: any) {
    this.isLoading = true;
    let list = [];
    // tslint:disable-next-line: radix
    switch (parseInt(event)) {
      case -1:
        this.listFilterResult = [...this.listFilterResult1];
        this.isLoading = false;
        break;
      case 1:
        list = [...this.listFilterResult1];
        this.listFilterResult = list.filter(item => item.isActive === 1);
        this.isLoading = false;
        break;
      case 0:
        list = [...this.listFilterResult1];
        this.listFilterResult = list.filter(item => item.isActive === 0);
        this.isLoading = false;
        break;
      default:
        break;
    }
  }

  public delete(listid: any) {
    const modelDelete = {
      listId: listid
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
        // status: 200
        this.ngOnInit();
        this.changeModel();
        if (result.error) {
          this.toastr.error(result.error);
        } else {
          this.toastr.success(result.success);
        }
        this.modalReference.dismiss();
      },
    );
  }

}
