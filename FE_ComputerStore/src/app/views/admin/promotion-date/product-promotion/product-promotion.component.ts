import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { productPromotionDModel } from '../../../../models/product-promotion-model';
import { ProductPromotionService } from '../../../../services/product-promotion/product-promotion.service';
import { UpdateProductPromotionComponent } from '../update-product-promotion/update-product-promotion.component';

@Component({
  selector: 'app-product-promotion',
  templateUrl: './product-promotion.component.html',
  styleUrls: ['./product-promotion.component.scss']
})
export class ProductPromotionComponent implements OnInit {

  @ViewChild(UpdateProductPromotionComponent) view!: UpdateProductPromotionComponent;
  list_product_promotion: Array<productPromotionDModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  isSelected = true;
  searchedKeyword: string;
  listFilterResult: productPromotionDModel[] = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: productPromotionDModel[] = [];
  constructor(
    private modalService: NgbModal,
    private productPromotionService: ProductPromotionService,
    private toastr: ToastrService
    ) {
    }

  
  ngOnInit(): void {
    this.fetchlist_product_promotion();
  }


  

  fetchlist_product_promotion() {
    this.isLoading = true;
    this.productPromotionService.getAll().subscribe(data => {
      this.list_product_promotion = data.data;
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
        var dc = item.product_name.toLowerCase();
        var hot_line = item.date.toString();
        if (hot_line.includes(keyword) || dc.includes(keyword)) {
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
      .filter((product_promotion) => product_promotion.checked)
      .map((p) => p.product_promotion_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  delete_product_promotion(item: any = null) {
    let selectedproduct_promotion= [];
    if (item !== null && item !== undefined && item !== '') {
      selectedproduct_promotion.push(item);
      this.delete(selectedproduct_promotion);
      return;
    }
    selectedproduct_promotion = this.listFilterResult
      .filter((product_promotion) => product_promotion.checked)
      .map((p) => p.product_promotion_id);
    if (selectedproduct_promotion.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedproduct_promotion);
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
        this.listFilterResult = [...this.list_product_promotion];
        this.isLoading = false;
        break;
      case 1:
        list = [...this.list_product_promotion];
        this.listFilterResult = list.filter(item => item.isActive === 1);
        this.isLoading = false;
        break;
      case 0:
        list = [...this.list_product_promotion];
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

    this.productPromotionService.delete(modelDelete).subscribe(
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
