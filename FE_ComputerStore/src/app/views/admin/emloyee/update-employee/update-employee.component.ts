import { DatePipe } from '@angular/common';
import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'angular-bootstrap-md';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { accountModel } from '../../../../models/account-model';
import { accountTypeModel } from '../../../../models/account-type-model';
import { AccountTypeService } from '../../../../services/account-type/account-type.service';
import { AccountService } from '../../../../services/account/account.service';

@Component({
  selector: 'app-update-employee',
  templateUrl: './update-employee.component.html',
  styleUrls: ['./update-employee.component.scss']
})
export class UpdateEmployeeComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_employee: Array<accountModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  arraylist_account_type: Array<accountTypeModel> = [];
  arrCheck = [];
  closeResult: String;
  uploadPercent: Observable<number>;
  downloadURL: Observable<string>;
  modalReference!: any;
  formGroup: FormGroup;
  subscription: Subscription;
  isAdd = false;
  image: string = null;
  isEdit = false;
  avatarUrl;
  isInfo = false;
  submitted = false;
  title = '';
  type: any;
  model: accountModel;
  urlPictureDefault = avatarDefault;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private datepipe: DatePipe,
    private employeeService: AccountService,
    private accountTypeService:AccountTypeService,
    private store: AngularFireStorage) {
      this.formGroup = new FormGroup({
        full_name: new FormControl(),
        email_employee: new FormControl(),
        address: new FormControl(),
        phone_number: new FormControl(),
        created_at: new FormControl(),
        password_employee:new FormControl(),
        account_type_id:new FormControl()
      });
  }

  ngOnInit(): void {
    this.submitted = false;
    this.fetchListEmployee();
    this.fetchListAccountType();
   

  }

  fetchListEmployee() {
    this.employeeService.getAccountOfEmployee().subscribe(data => {
      this.arraylist_employee = data.data;
      this.avatarUrl = data.data.image;
    })
  }

  fetchListAccountType() {
    this.accountTypeService.getAll().subscribe(data => {
      this.arraylist_account_type = data.data;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin nhân viên`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin nhân viên`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin nhân viên`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: accountModel, type = null): void {
    this.arrCheck = this.arraylist_employee;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    if (model.account_id === null || model.account_id === undefined) {
      this.formGroup = this.fb.group({
        full_name: [null, [Validators.required]],
        password_employee :[null, [Validators.required]],
        email_employee: [null, [Validators.required]],
        address: [null, [Validators.required]],
        phone_number: [null, [Validators.required]],
        account_type_id :[null, [Validators.required]],
        created_at: [this.datepipe.transform(Date.now(), 'shortDate')],
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        full_name: [{ value: this.model.full_name, disabled: this.isInfo }, [Validators.required]],
        password_employee: [{ value :'', disabled: this.isInfo }],
        email_employee: [{ value: this.model.email, disabled: this.isInfo }, [Validators.required]],
        address: [{ value: this.model.address, disabled: this.isInfo }, [Validators.required]],
        phone_number: [{ value: this.model.phone_number, disabled: this.isInfo }, [Validators.required]],
        account_type_id:[{ value: this.model.account_type_id, disabled: this.isInfo }, [Validators.required]],
        created_at: [{ value: this.model.created_at, disabled: this.isInfo }, [Validators.required]],
      });
      if (this.model.image === null) {
        this.urlPictureDefault = avatarDefault;
      }
      else {
        this.urlPictureDefault = this.model.image;
      }
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
    let employee: accountModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
    this.toastr.error('Kiểm tra thông tin các trường đã nhập', 'www.tiendatcomputer.vn cho biết');;
      return;
    }
    if (this.isEdit) {
      employee = {
        full_name: this.formGroup.get('full_name')?.value,
        email: this.formGroup.get('email_employee')?.value,
        address: this.formGroup.get('address')?.value,
        phone_number: this.formGroup.get('phone_number')?.value,
        account_type_id: this.formGroup.get('account_type_id')?.value,
        image: this.urlPictureDefault,
      };
    } else {
      employee = {
        full_name: this.formGroup.get('full_name')?.value,
        password: this.formGroup.get('password_employee')?.value,
        email: this.formGroup.get('email_employee')?.value,
        address: this.formGroup.get('address')?.value,
        phone_number: this.formGroup.get('phone_number')?.value,
        account_type_id: this.formGroup.get('account_type_id')?.value,
        image: this.urlPictureDefault,
      };
    }
    if (this.isAdd) {
      this.employeeService.create(employee).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho biết');
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
        }
      );
    }
    if (this.isEdit) {
      this.employeeService.update(employee).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success("Chỉnh sửa thành công","www.tiendatcomputer.vn cho biết");
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

  uploadImage(event) {
    let file = event.target.files[0];
    let path = `computerstore/employee/${file.name}`;
    if (file.type.split('/')[0] !== 'image') {
      return alert('Erreur, ce fichier n\'est pas une image');
    } else {
      let ref = this.store.ref(path);
      let task = this.store.upload(path, file);
      this.uploadPercent = task.percentageChanges();
      task.snapshotChanges().pipe(
        finalize(() => {
          this.downloadURL = ref.getDownloadURL();
          this.downloadURL.subscribe(url => {
            this.urlPictureDefault = url;
          });
        }
        )
      ).subscribe();
    }
  }

}
