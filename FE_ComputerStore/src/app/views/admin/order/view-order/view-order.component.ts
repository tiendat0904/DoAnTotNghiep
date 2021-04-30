import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../../../models/account-model';
import { billDetailModel } from '../../../../models/bill-detail-model';
import { billModel } from '../../../../models/bill-model';
import { AccountService } from '../../../../services/account/account.service';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';
import { UpdateOrderDetailComponent } from '../update-order-detail/update-order-detail.component';

@Component({
  selector: 'app-view-order',
  templateUrl: './view-order.component.html',
  styleUrls: ['./view-order.component.scss']
})
export class ViewOrderComponent implements OnInit {

  @ViewChild(UpdateOrderDetailComponent) view!: UpdateOrderDetailComponent;
  arraylist_bill_detail: Array<billDetailModel> = [];
  arraylist_customer: Array<accountModel> = [];
  arraylist_customer_filter: Array<accountModel> = [];
  arraylist_bill: Array<billModel> = [];
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
  update_bill_id: bigint;
  listFilterResult: billDetailModel[] = [];
  listFilterResult1: Array<billDetailModel> = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: billDetailModel[] = [];
  isCheckhdn = true;
  isCheckhdn1 = false;
  bill_id: any;
  update_employee_id= null;
  update_customer_id= null;
  update_into_money = 0.00;
  update_created_at : any;
  constructor(
    private modalService: NgbModal,
    private billDetailService: BillDetailService,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private router: Router,
    private employeeService: AccountService,
    private customerService: AccountService,
    private actRoute: ActivatedRoute,
    private billService: BillService
    ) {
      this.billService.getAll().subscribe(data => {
        this.arraylist_bill = data.data;
      },)
      
     
      
    }

  
  ngOnInit(): void {
    this.submitted = false;
    this.fetcharraylist_employee();
    this.fetcharraylist_customer();
    this.update_bill_id = this.actRoute.snapshot.params['id'];
    this.billService.detail(this.update_bill_id).subscribe(data => {
      this.arraylist_bill = data.data;
      if(data.data === undefined){
      }else{
        if(data.data.bill_id === undefined || data.data.bill_id === null){
        }
        else{
          
          this.update_customer_id = data.data.customer_name;
          this.update_employee_id = data.data.employee_name;
          this.update_total_money = data.data.total_money;
          this.update_into_money = data.data.into_money;
          this.update_created_at = data.data.created_at;
        }
      }
      
      
    },)
    
    this.formGroup = this.fb.group({
      bill_id: [this.update_bill_id],
      employee_id: [this.update_employee_id ],
      customer_id:[this.update_customer_id ],
      created_at: [this.update_created_at],
      total_money:[this.update_total_money ],
      into_money:[this.update_into_money ],
    });
    this.fetcharraylist_bill_detail();
  }

  save() {
    let check = false;
    let bill: billModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    bill = {
      employee_id: this.formGroup.get('employee_id')?.value,
      customer_id: this.formGroup.get('customer_id')?.value,
     
    };

    this.billService.create(bill).subscribe(res => {
      this.toastr.success(res.success);    
      this.isCheckhdn = false;
      this.isCheckhdn1 = true;
      
    },
    err => {
      this.toastr.error(err.error.error);
    }
    );
  } 

  fetcharraylist_bill(){
    this.arraylist_bill=[];
    this.isLoading =  true;
    this.billService.getAll().subscribe(data => {
      this.arraylist_bill = data.data;
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_employee(){
    this.arraylist_employee=[];
    this.isLoading =  true;
    this.employeeService.getAll().subscribe(data => {
      this.arraylist_employee = data.data;
      this.arraylist_employee_filter = this.arraylist_employee.filter(function (employee) {
        return employee.value === "NV";
      });
    },
    err => {
        this.isLoading = false;
      })
  }

  fetcharraylist_customer(){
    this.arraylist_customer=[];
    this.isLoading =  true;
    this.customerService.getAll().subscribe(data => {
      this.arraylist_customer = data.data;
      this.arraylist_customer_filter = this.arraylist_customer.filter(function (customer) {
        return customer.value === "KH";
      });
    },
    err => {
        this.isLoading = false;
      })
  }
  

  fetcharraylist_bill_detail() { 
    this.listFilterResult=[];
    this.listFilterResult1 =[];
    this.isLoading = true;
    this.billDetailService.getAll().subscribe(data => {
      this.arraylist_bill_detail = data.data;
      for(let item of this.arraylist_bill_detail){
        if(item.bill_id==this.update_bill_id){
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
        var dc = item.price.toString();
        var hot_line = item.product_name.toLowerCase();
        var ten = item.amount.toString();
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

  getNavigation(link, id){
    if(id === ''){
        this.router.navigate([link]);
    } else {
        this.router.navigate([link + '/' + id]);
    }
  }

  xoabillDetail(item: any = null) {
    let selectedbillDetail= [];
    if (item !== null && item !== undefined && item !== '') {
      selectedbillDetail.push(item);
      this.delete(selectedbillDetail);
      return;
    }
    selectedbillDetail = this.listFilterResult
      .filter((billDetail) => billDetail.checked)
      .map((p) => p.product_id);
    if (selectedbillDetail.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedbillDetail);
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

    this.billDetailService.delete(modelDelete).subscribe(
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
