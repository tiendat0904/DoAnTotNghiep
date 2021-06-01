import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { accountModel } from '../../../../models/account-model';
import { billDetailModel } from '../../../../models/bill-detail-model';
import { billModel } from '../../../../models/bill-model';
import { orderStatusModel } from '../../../../models/order-status-model';
import { orderTypeModel } from '../../../../models/order-type-model';
import { AccountService } from '../../../../services/account/account.service';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';
import { OrderStatusService } from '../../../../services/order-status/order-status.service';
import { OrderTypeService } from '../../../../services/order-type/order-type.service';
import { UpdateOrderDetailComponent } from '../update-order-detail/update-order-detail.component';

@Component({
  selector: 'app-update-order',
  templateUrl: './update-order.component.html',
  styleUrls: ['./update-order.component.scss']
})
export class UpdateOrderComponent implements OnInit {

  @ViewChild(UpdateOrderDetailComponent) view!: UpdateOrderDetailComponent;
  arraylist_bill_detail: Array<billDetailModel> = [];
  arraylist_customer: Array<accountModel> = [];
  arraylist_customer_filter: Array<accountModel> = [];
  arraylist_bill: Array<billModel> = [];
  arraylist_employee: Array<accountModel> = [];
  arraylist_employee_filter: Array<accountModel> = [];
  arraylist_order_type: Array<orderTypeModel> = [];
  arraylist_order_status: Array<orderStatusModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  update_total_money = 0.00;
  update_into_money = 0.00;
  submitted = false;
  formGroup: FormGroup;
  searchedKeyword: string;
  update_bill_id: any;
  listFilterResult: billDetailModel[] = [];
  listFilterResult1: Array<billDetailModel> = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: billDetailModel[] = [];
  isCheckhdn = true;
  isCheckhdn1 = false;
  bill_id: any;
  update_employee_id = null;
  // update_customer_id = null;
  update_created_at = null;
  update_order_type_id = null;
  update_order_status_id = null;
  update_name = null;
  update_address = null;
  update_phone_number = null;

  constructor(
    private modalService: NgbModal,
    private billDetailService: BillDetailService,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private router: Router,
    private employeeService: AccountService,
    private customerService: AccountService,
    private actRoute: ActivatedRoute,
    private billService: BillService,
    private orderTypeService: OrderTypeService,
    private orderStatusService: OrderStatusService,
    public loaderService:LoaderService 
  ) {
    // this.billService.getAll().subscribe(data => {
    //   this.arraylist_bill = data.data;
    //   // this.update_bill_id = this.arraylist_bill.length+1;
    // },)
  }


  ngOnInit(): void {
    this.searchedKeyword = '';
    this.submitted = false;
    this.fetcharraylistOrderStatus();
    this.fetcharraylistOrderType();
    this.fetcharraylist_employee();
    this.fetcharraylist_customer();
    this.update_bill_id = this.actRoute.snapshot.params['id'];
    this.update_employee_id = localStorage.getItem("account_id");
    this.billService.detail(this.update_bill_id).subscribe(data => {
      this.arraylist_bill = data.data;
      if (data.data === undefined) {
      } else {
        if (data.data.bill_id === undefined || data.data.bill_id === null) {
        }
        else {
          // this.update_customer_id = data.data.customer_id;
          this.update_total_money = data.data.total_money;
          this.update_into_money = data.data.into_money;
          this.update_created_at = data.data.created_at;
          this.update_order_type_id = data.data.order_type_id;
          this.update_order_status_id = data.data.order_status_id;
          this.update_name = data.data.name;
          this.update_phone_number = data.data.phone_number;
          this.update_address = data.data.address;
        }
      }
    })

    this.formGroup = this.fb.group({
      bill_id: [this.update_bill_id],
      employee_id: [this.update_employee_id],
      // customer_id: [this.update_customer_id],
      name : [this.update_name],
      phone_number: [this.update_phone_number],
      address : [this.update_address],
      created_at: [this.update_created_at],
      order_type_id:[this.update_order_type_id],
      order_status_id:[this.update_order_status_id],
      into_money: [this.update_into_money],
      total_money: [this.update_total_money],
    });
    this.fetcharraylist_bill_detail();
    
  }

  fetcharraylist_employee(){
    this.arraylist_employee=[];
    this.isLoading =  true;
    this.employeeService.getAll().subscribe(data => {
      this.arraylist_employee = data.data;
      this.arraylist_employee_filter = this.arraylist_employee.filter(employee => employee.value==="NV" || employee.value==="AD");
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_customer(){
    this.arraylist_customer=[];
    this.isLoading =  true;
    this.employeeService.getAll().subscribe(data => {
      this.arraylist_customer = data.data;
      this.arraylist_customer_filter = this.arraylist_customer.filter(employee => employee.value==="KH");
    },
    err => {
        this.isLoading = false;
      })
  }

  save() {
    let bill: billModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
    this.toastr.error('Kiểm tra thông tin các trường đã nhập', 'www.tiendatcomputer.vn cho biết');;
      return;
    }
    bill = {
      employee_id:this.formGroup.get('employee_id')?.value,
      order_status_id: this.formGroup.get('order_status_id')?.value,
      order_type_id: this.formGroup.get('order_type_id')?.value,
      address: this.formGroup.get('address')?.value,
      phone_number: this.formGroup.get('phone_number')?.value
    };

    this.billService.update(this.update_bill_id, bill).subscribe(res => {
      this.toastr.success("Cập nhật đơn hàng thành công");
      this.router.navigate(["/admin/order"]);
      this.isCheckhdn = false;
      this.isCheckhdn1 = true;

    },
      err => {
        this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
      }
    );
  }

  fetcharraylist_bill() {
    this.arraylist_bill = [];
    this.isLoading = true;
    this.billService.getAll().subscribe(data => {
      this.arraylist_bill = data.data;
      //this.update_bill_id = this.arraylist_bill.length+1;
    },
      err => {
        this.isLoading = false;
      })
  }

  fetcharraylistOrderStatus() {
    this.arraylist_order_status = [];
    this.isLoading = true;
    this.orderStatusService.getAll().subscribe(data => {
      this.arraylist_order_status = data.data;
    },
      err => {
        this.isLoading = false;
      })
  }

  fetcharraylistOrderType() {
    this.arraylist_order_type = [];
    this.isLoading = true;
    this.orderTypeService.getAll().subscribe(data => {
      this.arraylist_order_type = data.data;
    },
      err => {
        this.isLoading = false;
      })
  }


  fetcharraylist_bill_detail() {
    this.listFilterResult = [];
    this.listFilterResult1 = [];
    this.isLoading = true;
    this.billDetailService.getAll().subscribe(data => {
      this.arraylist_bill_detail = data.data;
      for (let item of this.arraylist_bill_detail) {
        if (item.bill_id == this.update_bill_id) {
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
      .filter((billDetail) => billDetail.checked)
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

  delete_bill_detail(item: any = null) {
    let selectedthongtincd = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedthongtincd.push(item);
      this.delete(selectedthongtincd);
      return;
    }
    selectedthongtincd = this.listFilterResult
      .filter((thongtincd) => thongtincd.checked)
      .map((p) => p.bill_id);
    if (selectedthongtincd.length === 0) {
     this.toastr.error('Chọn ít nhất một bản ghi để xóa.','www.tiendatcomputer.vn cho biết');
      return;
    }
    this.delete(selectedthongtincd);
  }

  initModal(model: any, type = null): void {
    this.view.view(model, type);
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
    this.billDetailService.delete(modelDelete).subscribe(
      (result) => {
        // status: 200
        this.ngOnInit();
        this.changeModel();
        if (result.error) {
          this.toastr.error(result.error.error, "www.tiendatcomputer.vn cho biết" );
        } else {
          this.toastr.success(result.success,'www.tiendatcomputer.vn cho biết');
        }
        this.modalReference.dismiss();
      },
    );
  }

}
