import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { voucherModel } from '../../../../models/voucher-model';
import { VoucherService } from '../../../../services/voucher/voucher.service';
import { UpdateVoucherComponent } from '../update-voucher/update-voucher.component';

@Component({
  selector: 'app-voucher',
  templateUrl: './voucher.component.html',
  styleUrls: ['./voucher.component.scss']
})
export class VoucherComponent implements OnInit {

  @ViewChild(UpdateVoucherComponent) view!: UpdateVoucherComponent;
  list_voucher: Array<voucherModel> = [];
  listFilterResult: voucherModel[] = [];
  filterResultTemplist: voucherModel[] = [];
  modalReference: any;
  isDelete = true;
  condition = true;
  closeResult: string;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private voucherService: VoucherService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.searchedKeyword = '';
    this.fetchListPromotionDate();
  }

  fetchListPromotionDate() {
    this.voucherService.getAll().subscribe(data => {
      this.list_voucher = data.data;
      this.listFilterResult = data.data;
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;
    })
  }

  public filterByKeyword() {
    var filterResult = [];
    this.condition = true;
    if (this.searchedKeyword.length == 0) {
      this.listFilterResult = this.filterResultTemplist;
    } else {
      this.listFilterResult = this.filterResultTemplist;
      var keyword = this.searchedKeyword.toLowerCase();
      this.listFilterResult.forEach(item => {
        var date = item.voucher_level.toString();
        var full_name = item.full_name.toString();
        if (date.includes(keyword) || full_name.includes(keyword)) {
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
      .filter((voucher) => voucher.checked)
      .map((p) => p.voucher_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;
    } else {
      this.isDelete = true;
    }
  }

  deleteVoucher(item: any = null) {
    let selectedvoucher = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedvoucher.push(item);
      this.delete(selectedvoucher);
      return;
    }
    selectedvoucher = this.listFilterResult
      .filter((voucher) => voucher.checked)
      .map((p) => p.voucher_id);
    if (selectedvoucher.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.','www.tiendatcomputer.vn cho biết');
      return;
    }
    this.delete(selectedvoucher);
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
    this.voucherService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListPromotionDate();
        this.changeModel();
        if (result.error) {
          this.toastr.error(result.error.error, 'www.tiendatcomputer.vn cho biết');
        } else {
          this.toastr.success(result.success, 'www.tiendatcomputer.vn cho biết');
        }
        this.modalReference.dismiss();
      },
    );
  }

}
