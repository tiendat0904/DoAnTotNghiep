import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
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
  // list_customer: Array<accountModel> = [];
  listFilterResult: accountModel[] = [];
  filterResultTemplist: accountModel[] = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private customerService: AccountService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.fetchListCustomer();
  }

  fetchListCustomer() {
    this.customerService.getAccountByCustomer().subscribe(data => {
      this.listFilterResult = data.data;
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

  deleteCustomer(item: any = null) {
    let selectedcustomer = [];
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
    this.customerService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListCustomer();
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
