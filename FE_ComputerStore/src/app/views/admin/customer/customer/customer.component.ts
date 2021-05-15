import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { accountModel } from '../../../../models/account-model';
import { AccountService } from '../../../../services/account/account.service';
import { UpdateCustomerComponent } from '../update-customer/update-customer.component';

@Component({
  selector: 'app-customer',
  templateUrl: './customer.component.html',
  styleUrls: ['./customer.component.scss']
})
export class CustomerComponent implements OnInit {

  @ViewChild(UpdateCustomerComponent) view!: UpdateCustomerComponent;
  list_customer: Array<accountModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  searchedKeyword: string;
  listFilterResult: accountModel[] = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: accountModel[] = [];
  constructor(
    private modalService: NgbModal,
    private customerService: AccountService,
    private toastr: ToastrService
    ) {
    }

  
  ngOnInit(): void {
    this.fetchlist_customer();
  }


  

  fetchlist_customer() {
    this.isLoading = true;
    this.customerService.getAll().subscribe(data => {
      this.list_customer = data.data;
      this.listFilterResult = this.list_customer.filter(function (customer) {
        return customer.value === "KH";
      });
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
        var dc = item.full_name.toLowerCase();
        var hot_line = item.phone_number.toString();
        var ten = item.email.toLowerCase();
        var ten1 = item.address.toLowerCase();
        if (hot_line.includes(keyword) || ten.includes(keyword) || dc.includes(keyword) || ten1.includes(keyword)) {
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
      .filter((customer) => customer.checked)
      .map((p) => p.account_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  delete_customer(item: any = null) {
    let selectedcustomer= [];
    if (item !== null && item !== undefined && item !== '') {
      selectedcustomer.push(item);
      this.delete(selectedcustomer);
      return;
    }
    selectedcustomer = this.listFilterResult
      .filter((customer) => customer.checked)
      .map((p) => p.account_id);
    if (selectedcustomer.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedcustomer);
  }

  initModal(model: any,type = null): void {
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

    this.customerService.delete(modelDelete).subscribe(
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
