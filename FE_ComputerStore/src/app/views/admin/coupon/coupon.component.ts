import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../loader/loader.service';
import { couponModel } from '../../../models/coupon-model';
import { CouponService } from '../../../services/coupon/coupon.service';

@Component({
  selector: 'app-coupon',
  templateUrl: './coupon.component.html',
  styleUrls: ['./coupon.component.scss']
})
export class CouponComponent implements OnInit {

  arraylist_coupon: Array<couponModel> = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  condition = true;
  isSelected = true;
  searchedKeyword: string;
  listFilterResult: couponModel[] = [];
  page = 1;
  pageSize = 5;
  filterResultTemplist: couponModel[] = [];
  constructor(
    private modalService: NgbModal,
    private couponService: CouponService,
    private toastr: ToastrService,
    private router: Router,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.searchedKeyword = '';
    this.fetchListCoupon();
  }

  fetchListCoupon() {
    this.couponService.getAll().subscribe(data => {
      this.arraylist_coupon = data.data;
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
        var dc = item.employee_name.toString();
        var hot_line = item.supplier_name.toLowerCase();
        var date = item.created_at.toString();
        if (hot_line.includes(keyword) || dc.includes(keyword) || date.includes(keyword)) {
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
      .filter((coupon) => coupon.checked)
      .map((p) => p.coupon_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;

    } else {
      this.isDelete = true;
    }
  }

  deleteCoupon(item: any = null) {
    let selectedcoupon = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedcoupon.push(item);
      this.delete(selectedcoupon);
      return;
    }
    selectedcoupon = this.listFilterResult
      .filter((coupon) => coupon.checked)
      .map((p) => p.coupon_id);
    if (selectedcoupon.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.', "www.tiendatcomputer.vn cho biết");
      return;
    }
    this.delete(selectedcoupon);
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
    this.couponService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListCoupon();
        this.changeModel();
        if (result.error) {
          this.toastr.error(result.error, "www.tiendatcomputer.vn cho biết");
        } else {
          this.toastr.success(result.success, "www.tiendatcomputer.vn cho biết");
        }
        this.modalReference.dismiss();
      },
    );
  }
}
