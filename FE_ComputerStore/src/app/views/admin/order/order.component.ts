import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../loader/loader.service';
import { billModel } from '../../../models/bill-model';
import { BillService } from '../../../services/bill/bill.service';

@Component({
  selector: 'app-order',
  templateUrl: './order.component.html',
  styleUrls: ['./order.component.scss']
})
export class OrderComponent implements OnInit {

  arraylist_order: Array<billModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  searchedKeyword: string;
  listFilterResult: billModel[] = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: billModel[] = [];
  constructor(
    private modalService: NgbModal,
    private orderService: BillService,
    private toastr: ToastrService,
    private router: Router,
    public loaderService:LoaderService 
  ) {
  }


  ngOnInit(): void {
    this.fetcharraylist_order();
  }

  getColor(color) {
    (5)
    switch (color) {
      case "SELECTING":
        return '#5bc0de';
      case "PENDING":
        return 'rgb(255 150 0)';
      case "PROCESSING":
        return '#337ab7';
      case "PROCESSING":
        return '#337ab7';
      case "SHIPPING":
        return "rgb(99, 90, 90)";
      case "DONE":
        return '#5cb85c';
      case "CANCEL":
        return "d9534f";
    }
  }


  fetcharraylist_order() {
    this.isLoading = true;
    this.orderService.getAll().subscribe(data => {
      this.arraylist_order = data.data;
      this.listFilterResult = data.data;
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;
      for(let item of this.filterResultTemplist){
        if(item.order_status_id === 1 || item.order_status_id === 6){
          item.check_order_status = false;
        }else{
          item.check_order_status = true;
        }
      }
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
      console.log(this.listFilterResult);
      this.listFilterResult.forEach(item => {
        // var dc = item.employee_name.toLowerCase();
        var hot_line = item.name.toLowerCase();
        if (hot_line.includes(keyword) ) {
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
      .filter((order) => order.checked)
      .map((p) => p.bill_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  delete_order(item: any = null) {
    let selectedorder = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedorder.push(item);
      this.delete(selectedorder);
      return;
    }
    selectedorder = this.listFilterResult
      .filter((order) => order.checked)
      .map((p) => p.bill_id);
    if (selectedorder.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedorder);
  }

  // initModal(model: any,type = null): void {
  //   this.view.view(model, type);
  // }

  changeStatus(event: any) {
    this.isLoading = true;
    let list = [];
    // tslint:disable-next-line: radix
    switch (parseInt(event)) {
      case 0:
        this.listFilterResult = [...this.arraylist_order];
        this.isLoading = false;
        break;
      case 1:
        list = [...this.arraylist_order];
        this.listFilterResult = list.filter(item => item.order_status_id === 1);
        this.isLoading = false;
        break;
      case 2:
        list = [...this.arraylist_order];
        this.listFilterResult = list.filter(item => item.order_status_id === 2);
        this.isLoading = false;
        break;
      case 3:
        list = [...this.arraylist_order];
        this.listFilterResult = list.filter(item => item.order_status_id === 3);
        this.isLoading = false;
        break;
      case 4:
        list = [...this.arraylist_order];
        this.listFilterResult = list.filter(item => item.order_status_id === 4);
        this.isLoading = false;
        break;
      case 5:
        list = [...this.arraylist_order];
        this.listFilterResult = list.filter(item => item.order_status_id === 5);
        this.isLoading = false;
        break;
      case 6:
        list = [...this.arraylist_order];
        this.listFilterResult = list.filter(item => item.order_status_id === 6);
        this.isLoading = false;
        break;
      default:
        break;
    }
  }

  getNavigation(link, id) {
    if (id === '') {
      this.router.navigate([link]);
    } else {
      this.router.navigate([link + '/' + id]);
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

    this.orderService.delete(modelDelete).subscribe(
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
