import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { supplierModel } from '../../../../models/supplier-model';
import { SupplierService } from '../../../../services/supplier/supplier.service';

@Component({
  selector: 'app-update-supplier',
  templateUrl: './update-supplier.component.html',
  styleUrls: ['./update-supplier.component.scss']
})
export class UpdateSupplierComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_supplier: Array<supplierModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  closeResult: String;
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  modalReference!: any;
  formGroup: FormGroup;
  subscription: Subscription;
  isAdd = false;
  isEdit = false;
  isEditimage = false;
  isInfo = false;
  submitted = false;
  title = '';
  type: any;
  arrCheck = [];
  model: supplierModel;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private supplierService: SupplierService
    ) {}

  ngOnInit(): void {
    this.submitted = false;
    this.fetchListSupplier();
  }

  fetchListSupplier() {
    this.subscription = this.supplierService.getAll().subscribe(data => {
      this.arraylist_supplier = data.data;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin nhà cung cấp`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin nhà cung cấp`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin nhà cung cấp`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: supplierModel, type = null): void {
    this.arrCheck = this.arraylist_supplier;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    if (model.supplier_id === null || model.supplier_id === undefined) {
      this.formGroup = this.fb.group({
        ten: [null, [Validators.required]],
        dia_chi: [null, [Validators.required]],
        hot_line: [null, [Validators.required]],
        email: [null, [Validators.required, Validators.pattern(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i)]],
      });
    } else {
      this.formGroup = this.fb.group({
        ten: [{ value: this.model.supplier_name, disabled: this.isInfo }, [Validators.required]],
        dia_chi: [{ value: this.model.supplier_address, disabled: this.isInfo }, [Validators.required]],
        hot_line: [{ value: this.model.hotline, disabled: this.isInfo }, [Validators.required]],
        email: [{ value: this.model.email, disabled: this.isInfo }, [Validators.required, Validators.pattern(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i)]],

      });
    }
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
      centered: true,
      size: 'md',
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
    let nhacungcap: supplierModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      nhacungcap = {
        supplier_id: this.model.supplier_id,
        supplier_name: this.formGroup.get('ten')?.value,
        supplier_address: this.formGroup.get('dia_chi')?.value,
        hotline: this.formGroup.get('hot_line')?.value,
        email: this.formGroup.get('email')?.value,
      };

    } else {
      nhacungcap = {
        supplier_id: this.model.supplier_id,
        supplier_name: this.formGroup.get('ten')?.value,
        supplier_address: this.formGroup.get('dia_chi')?.value,
        hotline: this.formGroup.get('hot_line')?.value,
        email: this.formGroup.get('email')?.value,
      };
    }
    if (this.isAdd) {
      for (let i = 0; i < this.arrCheck.length; i++) {
        if (this.arrCheck[i].supplier_id === nhacungcap.supplier_id) {
          check = true;
          break;
        }
      }
      if (check === true) {
        this.toastr.error('Mã nhà cung cấp đã tồn tại');
        return;
      }
      this.supplierService.create(nhacungcap).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success);
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error);
        }
      );
    }
    if (this.isEdit) {
      this.supplierService.update(nhacungcap.supplier_id, nhacungcap).subscribe(res => {
        this.modalReference.dismiss();
        this.closeModalReloadData();
        this.toastr.success(res.success);
      },
        err => {
          this.toastr.error(err.error.error);
        }
      );
    }
  }

  public closeModalReloadData(): void {
    this.submitted = false;
    this.eventEmit.emit('success');
  }
}
