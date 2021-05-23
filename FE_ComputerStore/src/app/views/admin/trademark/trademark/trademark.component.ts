import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
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
  modalReference: any;
  isDelete = true;
  closeResult: string;
  condition = true;
  searchedKeyword: string;
  list_supplier: Array<trademarkModel> = [];
  listFilterResult: trademarkModel[] = [];
  filterResultTemplist: trademarkModel[] = [];
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private trademarkService: TrademarkService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.fetchlistSupplier();
  }

  fetchlistSupplier() {
    this.trademarkService.getAll().subscribe(data => {
      this.list_supplier = data.data;
      this.listFilterResult = data.data;
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;
    })
  }

  public filterByKeyword() {
    var filterResult = [];
    this.condition = true;
    if (this.searchedKeyword.length == 0) {
      this.condition = true;
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
      if (this.listFilterResult.length !== 0) {
        this.condition = true;
      } else {
        this.condition = false;
      }
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

  deleteTrademark(item: any = null) {
    let selectedsupplier = [];
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
    this.trademarkService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchlistSupplier();
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
