import { DatePipe } from '@angular/common';
import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
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
  selector: 'app-create-order',
  templateUrl: './create-order.component.html',
  styleUrls: ['./create-order.component.scss']
})
export class CreateOrderComponent implements OnInit {

  @ViewChild(UpdateOrderDetailComponent) view!: UpdateOrderDetailComponent;
  arraylist_bill_detail: Array<billDetailModel> = [];
  arraylist_customer: Array<accountModel> = [];
  arraylist_customer_filter:Array<accountModel> = [];
  arraylist_employee_filter: Array<accountModel> = [];
  arraylist_bill: Array<billModel> = [];
  arraylist_employee: Array<accountModel> = [];
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
  isAdd : Boolean;
  listFilterResult: billDetailModel[] = [];
  listFilterResult1: Array<billDetailModel> = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: billDetailModel[] = [];
  isCheckhdn = true;
  isCheckhdn1 = false;
  isButtonSave = false;
  bill_id: any;
  update_bill_id1 :any;
  update_employee_id= null;
  update_customer_id= null;
  bill: billModel;
  constructor(
    private modalService: NgbModal,
    private billDetailService: BillDetailService,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private router: Router,
    private employeeService: AccountService,
    private customerService: AccountService,
    private billService: BillService,
    private datePipe: DatePipe
    ) {
      this.billService.getAll().subscribe(data => {
        this.arraylist_bill = data.data;
        this.update_bill_id = this.arraylist_bill[this.arraylist_bill.length-1].bill_id;
        this.update_bill_id = this.update_bill_id+1;
      },)
      
     
      
      this.formGroup = this.fb.group({
        bill_id: [this.update_bill_id],
        employee_id: [ null,[Validators.required]],
        customer_id:[ null,[Validators.required]],
        created_at: [this.datePipe.transform(Date.now(),"dd/MM/yyyy")],
        total_money:[this.update_total_money],
        into_money:[this.update_into_money],
      });
    }

  
  ngOnInit(): void {
    this.searchedKeyword = '';
    this.isAdd = true;
    this.fetcharraylist_bill_detail();
    this.submitted = false;
    this.fetcharraylist_employee();
    this.fetcharraylist_customer();
    this.billService.detail(this.update_bill_id).subscribe(data => {
      this.arraylist_bill = data.data;
      if(data.data === undefined){
      }else{
        if(data.data.bill_id === undefined || data.data.bill_id === null){
          
        }
        else{
          
          this.update_customer_id = data.data.customer_id;
          this.update_employee_id = data.data.employee_id;
          this.update_total_money = data.data.total_money;
          this.update_into_money = data.data.into_money;
        }
      }
      
      
    },)
    
  }

  save() {
    let check = false;
    
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    this.bill = {
      employee_id: this.formGroup.get('employee_id')?.value,
      customer_id: this.formGroup.get('customer_id')?.value,
     
    };
    this.isButtonSave = true;
    this.isCheckhdn = false;
    this.isCheckhdn1 = true;

    
  } 

  fetcharraylist_bill(){
    this.arraylist_bill=[];
    this.isLoading =  true;
    this.billService.getAll().subscribe(data => {
      this.arraylist_bill = data.data;
      this.update_bill_id = this.arraylist_bill.length+1;
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
        if(item.bill_id===this.update_bill_id){
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
      .filter((billDetail) => billDetail.checked)
      .map((p) => p.product_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  getNavigation(link, id){
    if(this.listFilterResult.length===0){
      
      this.router.navigate([link]);
    }else{
      
      this.router.navigate([link]);
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
