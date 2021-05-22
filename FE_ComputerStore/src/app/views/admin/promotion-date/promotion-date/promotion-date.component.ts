import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { promotionDateModel } from '../../../../models/promotion-date-model';
import { PromotionDateService } from '../../../../services/promotion-date/promotion-date.service';
import { UpdatePromotionDateComponent } from '../update-promotion-date/update-promotion-date.component';

@Component({
  selector: 'app-promotion-date',
  templateUrl: './promotion-date.component.html',
  styleUrls: ['./promotion-date.component.scss']
})
export class PromotionDateComponent implements OnInit {

  @ViewChild(UpdatePromotionDateComponent) view!: UpdatePromotionDateComponent;
  list_promotion_date: Array<promotionDateModel> = [];
  listFilterResult: promotionDateModel[] = [];
  filterResultTemplist: promotionDateModel[] = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private promotionDateService: PromotionDateService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.fetchListPromotionDate();
  }

  fetchListPromotionDate() {
    this.promotionDateService.getAll().subscribe(data => {
      this.list_promotion_date = data.data;
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
        var date = item.date.toString();
        if (date.includes(keyword)) {
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
      .filter((promotion_date) => promotion_date.checked)
      .map((p) => p.promotion_date_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;
    } else {
      this.isDelete = true;
    }
  }

  deletePromotionDate(item: any = null) {
    let selectedpromotion_date = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedpromotion_date.push(item);
      this.delete(selectedpromotion_date);
      return;
    }
    selectedpromotion_date = this.listFilterResult
      .filter((promotion_date) => promotion_date.checked)
      .map((p) => p.promotion_date_id);
    if (selectedpromotion_date.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedpromotion_date);
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
    this.promotionDateService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListPromotionDate();
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
