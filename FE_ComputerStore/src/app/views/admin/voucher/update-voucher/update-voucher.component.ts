import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'angular-bootstrap-md';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { accountModel } from '../../../../models/account-model';
import { voucherModel } from '../../../../models/voucher-model';
import { AccountService } from '../../../../services/account/account.service';
import { VoucherService } from '../../../../services/voucher/voucher.service';

@Component({
  selector: 'app-update-voucher',
  templateUrl: './update-voucher.component.html',
  styleUrls: ['./update-voucher.component.scss']
})
export class UpdateVoucherComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_voucher: Array<voucherModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  list_customer: Array<accountModel> = [];
  arraylist_voucher_filter: Array<voucherModel> = [];
  list_customer_filter: Array<accountModel> = [];
  list_customer_main: Array<accountModel> = [];
  filterResultTemplist: accountModel[] = [];
  list_customer_select: Array<accountModel> = [];
  closeResult: String;
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  modalReference!: any;
  formGroup: FormGroup;
  subscription: Subscription;
  isAdd = false;
  image: string = null;
  isEdit = false;
  isEditimage = false;
  isInfo = false;
  submitted = false;
  title = '';
  type: any;
  condition = true;
  arrCheck = [];
  update_ma_tai_khoan: any;
  model: voucherModel;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;
  checkedCustomer: boolean;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private customerService: AccountService,
    private voucherService: VoucherService,
  ) { }

  ngOnInit(): void {
    this.searchedKeyword = '';
    this.submitted = false;
    this.fetchListPromotionDate();
    this.fetchListCustomer();
  }

  fetchListCustomer() {
    this.searchedKeyword = null;
    this.subscription = this.customerService.getAccountCustomer().subscribe(data => {
      this.list_customer = data.data;
      this.list_customer.forEach((x) => (x.checked = false));
      this.checkedCustomer = true;
      this.list_customer_main = this.list_customer;
      this.filterResultTemplist = this.list_customer;
    })
  }

  fetchListPromotionDate() {
    this.formGroup = new FormGroup({
      startDate: new FormControl(),
      endDate: new FormControl(),
      voucher_level: new FormControl()
    });
    this.subscription = this.voucherService.getAll().subscribe(data => {
      this.arraylist_voucher = data.data;
    })
  }

  public filterByKeyword() {
    this.condition = true;
    if (this.isAdd) {
      var filterResult = [];
      if (this.searchedKeyword.length == 0) {
        this.list_customer = this.filterResultTemplist;
      } else {
        this.list_customer = this.filterResultTemplist;
        var keyword = this.searchedKeyword.toLowerCase();
        this.list_customer.forEach(item => {
          var name = item.full_name.toLowerCase();
          var trademark = item.email.toLowerCase();
          var customer_type_name = item.phone_number.toLowerCase();
          if (name.includes(keyword) || trademark.includes(keyword) || customer_type_name.includes(keyword)) {
            filterResult.push(item);
          }
        });
        this.list_customer = filterResult;
        if (this.list_customer.length !== 0) {
          this.condition = true;
        } else {
          this.condition = false;
        }
      }
    } else {
      var filterResult = [];
      if (this.searchedKeyword.length == 0) {
        this.list_customer = this.filterResultTemplist;
        this.changeModel();
      } else {
        this.list_customer = this.filterResultTemplist;
        var keyword = this.searchedKeyword.toLowerCase();
        this.list_customer.forEach(item => {
          var name = item.full_name.toLowerCase();
          var trademark = item.email.toLowerCase();
          var customer_type_name = item.phone_number.toLowerCase();
          if (name.includes(keyword) || trademark.includes(keyword) || customer_type_name.includes(keyword)) {
            filterResult.push(item);
          }
        });
        this.list_customer = filterResult;
      }
    }
  }

  checkAllCheckBox(ev) {
    this.list_customer.forEach((x) => (x.checked = ev.target.checked));
    this.list_customer.sort(function (a, b) {
      return Number(b.checked) - Number(a.checked);
    });
    this.changeModel();
  }

  isAllCheckBoxChecked() {
    this.list_customer.sort(function (a, b) {
      return Number(b.checked) - Number(a.checked);
    });
    return this.list_customer.every((p) => p.checked);

  }

  changeModel() {
    const selectedHometowns = this.list_customer
      .filter((customer) => customer.checked)
      .map((p) => p.account_id);
    if (selectedHometowns.length > 0) {
      this.checkedCustomer = false;
    } else {
      this.checkedCustomer = true;
    }
  }

  resetCustomer() {
    this.list_customer.forEach((x) => (x.checked = false));
    this.checkedCustomer = true;
  }


  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin voucher`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin voucher`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin voucher`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: voucherModel, type = null): void {
    this.arrCheck = this.arraylist_voucher;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    console.log(model);
    if (model.voucher_id === null || model.voucher_id === undefined) {
      this.formGroup = this.fb.group({
        startDate: [null, [Validators.required]],
        endDate: [null, [Validators.required]],
        voucher_level: [null, [Validators.required]],
      });
      this.list_customer = this.list_customer_main;
      for (var i = 0; i < this.list_customer.length; i++) {
        if (this.list_customer[i].checked == true) {
          this.list_customer[i].checked = false;
        }
      }
      this.searchedKeyword = null;
      this.checkedCustomer = true;
      this.filterResultTemplist = this.list_customer;
    } else {
      // if (this.isEdit) {
        this.list_customer = this.list_customer_main;
        this.list_customer_select = [];
        this.voucherService.detail(model.voucher_id).subscribe(data => {
          this.arraylist_voucher_filter = data.data;
          this.formGroup = this.fb.group({
            startDate: [{ value: this.model.startDate, disabled: this.isAdd }, [Validators.required]],
            endDate: [{ value: this.model.endDate, disabled: this.isAdd }, [Validators.required]],
            voucher_level: [{ value: this.arraylist_voucher_filter[0].voucher_level, disabled: this.isAdd }, [Validators.required]],
          });
          for (let item of this.arraylist_voucher_filter) {
            this.list_customer_select.push(item.listCustomer[0]);
          }
          for (let item of this.list_customer) {
            for (let item1 of this.list_customer_select) {
              if (item.account_id === item1.account_id) {
                item.checked = true;
              }
            }
          }
         
         
          this.list_customer.sort(function (a, b) {
            return Number(b.checked) - Number(a.checked);
          });
          this.changeModel();
          this.filterResultTemplist = this.list_customer;
        })
      // } else {
      //   this.list_customer_select = [];
      //   this.voucherService.detail(model.voucher_id).subscribe(data => {
      //     this.arraylist_voucher_filter = data.data;
      //     this.formGroup = this.fb.group({
      //       startDate: [{ value: this.model.startDate, disabled: this.isInfo }, [Validators.required]],
      //       endDate: [{ value: this.model.endDate, disabled: this.isInfo }, [Validators.required]],
      //       voucher_level: [{ value: this.arraylist_voucher_filter[0].voucher_level, disabled: this.isInfo }, [Validators.required]],
      //     });
      //     for (let item of this.arraylist_voucher_filter) {
      //       this.list_customer_select.push(item.listCustomer[0]);
      //     }
      //     this.list_customer = this.list_customer_select;
      //   })
      // }
    }
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
      centered: true,
      size: <any>'xl',
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

  save() {
    let check = false;
    let voucher: voucherModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
    this.toastr.error('Kiểm tra thông tin các trường đã nhập', 'www.tiendatcomputer.vn cho biết');;
      return;
    }
    if (this.isEdit) {
      this.list_customer_filter = this.filterResultTemplist.filter(customer => customer.checked === true);
      voucher = {
        startDate: this.formGroup.get('startDate')?.value,
        endDate: this.formGroup.get('endDate')?.value,
        voucher_level: this.formGroup.get('voucher_level').value,
        listCustomer: this.list_customer_filter
      };
    } else {
      this.list_customer_filter = this.filterResultTemplist.filter(customer => customer.checked === true);
      voucher = {
        startDate: this.formGroup.get('startDate')?.value,
        endDate: this.formGroup.get('endDate')?.value,
        voucher_level: this.formGroup.get('voucher_level').value,
        listCustomer: this.list_customer_filter
      };
    }
    if (this.isAdd) {
      if (this.list_customer_filter.length !== 0) {
        this.voucherService.create(voucher).subscribe(res => {
          console.log(res.success);
          for (var i = 0; i < this.list_customer.length; i++) {
            if (this.list_customer[i].checked == true) {
              this.list_customer[i].checked = false;
            }
          }
          this.searchedKeyword = null;
          this.filterResultTemplist = this.list_customer;
          this.closeModalReloadData();
          this.toastr.success(res.success, 'www.tiendatcomputer.vn cho biết');
          this.modalReference.dismiss();
        },
          err => {
            this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
          }
        );
      } else {
        this.toastr.warning("Vui lòng chọn sản phẩm khuyến mãi!!!");
      }
    }
    if (this.isEdit) {
      const modelDelete = {
        id: this.model.voucher_id
      };
      this.voucherService.delete(modelDelete).subscribe();
      this.voucherService.create(voucher).subscribe(res => {
        for (var i = 0; i < this.list_customer.length; i++) {
          if (this.list_customer[i].checked == true) {
            this.list_customer[i].checked = false;
          }
        }
        this.searchedKeyword = null;
        this.filterResultTemplist = this.list_customer;
        this.closeModalReloadData();
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho biết');
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
        }
      );
    }
  }

  public closeModalReloadData(): void {
    this.submitted = false;
    this.eventEmit.emit('success');
  }
}
