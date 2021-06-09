import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { productTypeModel } from '../../../../models/product-type-model';
import { ProductTypeService } from '../../../../services/product-type/product-type.service';
import { UpdateProductTypeComponent } from '../update-product-type/update-product-type.component';

@Component({
  selector: 'app-product-type',
  templateUrl: './product-type.component.html',
  styleUrls: ['./product-type.component.scss']
})
export class ProductTypeComponent implements OnInit {

  @ViewChild(UpdateProductTypeComponent) view!: UpdateProductTypeComponent;
  arraylist_product_type: Array<productTypeModel> = [];
  listFilterResult: productTypeModel[] = [];
  filterResultTemplist: productTypeModel[] = [];
  modalReference: any;
  isDelete = true;
  condition = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private productTypeService: ProductTypeService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.searchedKeyword = '';
    this.fetchListProductImage();
  }

  fetchListProductImage() {
    this.isLoading = true;
    this.productTypeService.getAll().subscribe(data => {
      this.arraylist_product_type = data.data;
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
        var name = item.product_type_name.toLowerCase();
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
      .filter((product_type) => product_type.checked)
      .map((p) => p.product_type_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  deleteProductImage(item: any = null) {
    let selectedproduct_type = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedproduct_type.push(item);
      this.delete(selectedproduct_type);
      return;
    }
    selectedproduct_type = this.listFilterResult
      .filter((product_type) => product_type.checked)
      .map((p) => p.product_type_id);
    if (selectedproduct_type.length === 0) {
     this.toastr.error('Chọn ít nhất một bản ghi để xóa.','www.tiendatcomputer.vn cho biết');
      return;
    }
    this.delete(selectedproduct_type);
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

    this.productTypeService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListProductImage();
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
