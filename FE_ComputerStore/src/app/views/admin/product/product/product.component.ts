import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { productModel } from '../../../../models/product-model';
import { ProductService } from '../../../../services/product/product.service';
import { UpdateProductComponent } from '../update-product/update-product.component';

@Component({
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss']
})
export class ProductComponent implements OnInit {

  @ViewChild(UpdateProductComponent) view!: UpdateProductComponent;
  list_product: Array<productModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  condition = true;
  searchedKeyword: string;
  listFilterResult: productModel[] = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: productModel[] = [];
  constructor(
    private modalService: NgbModal,
    private productService: ProductService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.fetchListProduct();

  }

  fetchListProduct() {
    this.searchedKeyword = '';
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
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
        var name = item.product_name.toLowerCase();
        var trademark = item.trademark_name.toLowerCase();
        var product_type_name = item.product_type_name.toLowerCase();
        if (name.includes(keyword) || trademark.includes(keyword) || product_type_name.includes(keyword)) {
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
      .filter((product) => product.checked)
      .map((p) => p.product_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  deleteProduct(item: any = null) {
    let selectedproduct = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedproduct.push(item);
      this.delete(selectedproduct,item);
      return;
    }
    selectedproduct = this.listFilterResult
      .filter((product) => product.checked)
      .map((p) => p.product_id);
    if (selectedproduct.length === 0) {
     this.toastr.error('Ch???n ??t nh???t m???t b???n ghi ????? x??a.','www.tiendatcomputer.vn cho bi???t');
      return;
    }
    this.delete(selectedproduct);
  }

  initModal(model: any, type = null): void {
    this.view.view(model, type);
  }

  public delete(listid: any,product_id:any = null) {
    const modelDelete = {
      listId: listid,
      product_id:product_id
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
    this.productService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListProduct();
        this.changeModel();
        this.toastr.success(result.success,'www.tiendatcomputer.vn cho bi???t');
        // }
        // if (result.error) {
        //   this.toastr.error(result.error.error, "www.tiendatcomputer.vn cho bi???t" );
        // } else {
        //   this.toastr.success(result.success,'www.tiendatcomputer.vn cho bi???t');
        // }
        this.modalReference.dismiss();
      },err =>{
        this.toastr.error(err.error.error, "www.tiendatcomputer.vn cho bi???t" );
        this.modalReference.dismiss();
      }
    );
  }

}
