import { Component, OnInit, ViewChild } from '@angular/core';
import { ToastrService } from 'ngx-toastr';
import { supplierModel } from '../../../../models/supplier-model';
import { SupplierService } from '../../../../services/supplier/supplier.service';
import { NgbModal, ModalDismissReasons } from '@ng-bootstrap/ng-bootstrap';
import { UpdateSupplierComponent } from '../update-supplier/update-supplier.component';
import { LoaderService } from '../../../../loader/loader.service';

@Component({
  selector: 'app-supplier',
  templateUrl: './supplier.component.html',
  styleUrls: ['./supplier.component.scss']
})
export class SupplierComponent implements OnInit {

  @ViewChild(UpdateSupplierComponent) view!: UpdateSupplierComponent;
  list_supplier: Array<supplierModel> = [];
  listFilterResult: supplierModel[] = [];
  filterResultTemplist: supplierModel[] = [];
  modalReference: any;
  condition = true;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  // isSelected = true;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private supplierService: SupplierService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.fetchListSupplier();
  }

  fetchListSupplier() {
    this.isLoading = true;
    this.supplierService.getAll().subscribe(data => {
      this.list_supplier = data.data;
      this.listFilterResult = data.data;
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;
    })
  }

  public filterByKeyword() {
    this.condition = true;
    var filterResult = [];
    if (this.searchedKeyword.length == 0) {
      this.listFilterResult = this.filterResultTemplist;
    } else {
      this.listFilterResult = this.filterResultTemplist;
      var keyword = this.searchedKeyword.toLowerCase();
      this.listFilterResult.forEach(item => {
        var dc = item.supplier_address.toLowerCase();
        var hot_line = item.hotline.toLowerCase();
        var ten = item.supplier_name.toLowerCase();
        if (hot_line.includes(keyword) || ten.includes(keyword)) {
          filterResult.push(item);
        }
      });
      this.listFilterResult = filterResult;
      if(this.listFilterResult.length !== 0){
        this.condition = true;
      }else{
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
      .map((p) => p.supplier_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;
    } else {
      this.isDelete = true;
    }
  }

  deleteSupplier(item: any = null) {
    let selectedsupplier = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedsupplier.push(item);
      this.delete(selectedsupplier);
      return;
    }
    selectedsupplier = this.listFilterResult
      .filter((supplier) => supplier.checked)
      .map((p) => p.supplier_id);
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
    for (var i = 0; i < this.listFilterResult.length; i++) {
      if (this.listFilterResult[i].checked == true) {
        this.listFilterResult[i].checked = false;
      }
    }
    this.searchedKeyword = null;
    this.filterResultTemplist = this.listFilterResult;
    this.supplierService.delete(modelDelete).subscribe(
      (result) => {
        this.modalReference.dismiss();
        this.fetchListSupplier();
        this.changeModel();
        if (result.error) {
          this.toastr.error(result.error);
        } else {
          this.toastr.success(result.success);
        }
      },
    );
  }
}
