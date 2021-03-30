import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { trademarkModel } from '../../../../models/trademark-model';
import { TrademarkService } from '../../../../services/trademark/trademark.service';
import { UpdateTrademarkComponent } from '../update-trademark/update-trademark/update-trademark.component';

@Component({
  selector: 'app-trademark',
  templateUrl: './trademark.component.html',
  styleUrls: ['./trademark.component.scss']
})
export class TrademarkComponent implements OnInit {

  @ViewChild(UpdateTrademarkComponent) view!: UpdateTrademarkComponent;
  list_supplier: Array<trademarkModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  searchedKeyword: string;
  listFilterResult: trademarkModel[] = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: trademarkModel[] = [];
  constructor(
    private modalService: NgbModal,
    private trademarkService: TrademarkService,
    private toastr: ToastrService
    ) {
    }

  
  ngOnInit(): void {
    this.fetchlist_supplier();
  }


  

  fetchlist_supplier() {
    this.isLoading = true;
    this.trademarkService.getAll().subscribe(data => {
      this.list_supplier = data.data;
      this.listFilterResult = data.data;
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
        var name = item.trademark_name.toLowerCase();
        if (name.includes(keyword)) {
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
      .filter((supplier) => supplier.checked)
      .map((p) => p.trademark_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  delete_supplier(item: any = null) {
    let selectedsupplier= [];
    if (item !== null && item !== undefined && item !== '') {
      selectedsupplier.push(item);
      this.delete(selectedsupplier);
      return;
    }
    selectedsupplier = this.listFilterResult
      .filter((supplier) => supplier.checked)
      .map((p) => p.trademark_id);
    if (selectedsupplier.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedsupplier);
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
        this.listFilterResult = [...this.list_supplier];
        this.isLoading = false;
        break;
      case 1:
        list = [...this.list_supplier];
        this.listFilterResult = list.filter(item => item.isActive === 1);
        this.isLoading = false;
        break;
      case 0:
        list = [...this.list_supplier];
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

    this.trademarkService.delete(modelDelete).subscribe(
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
