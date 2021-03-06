import { DatePipe } from '@angular/common';
import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { AngularFireStorage } from '@angular/fire/storage';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { avatarDefault } from '../../../../../environments/environment';
import { accountModel } from '../../../../models/account-model';
import { AccountService } from '../../../../services/account/account.service';

@Component({
  selector: 'app-update-customer',
  templateUrl: './update-customer.component.html',
  styleUrls: ['./update-customer.component.scss']
})
export class UpdateCustomerComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_customer: Array<accountModel>;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  // list_customer: Array<accountModel> = [];
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
    private customerService: AccountService,
    private store: AngularFireStorage) {
  }

  ngOnInit(): void {
    this.submitted = false;
    this.fetchListCustomer();
    this.formGroup = new FormGroup({
      full_name: new FormControl(),
      email: new FormControl(),
      address: new FormControl(),
      phone_number: new FormControl(),
      created_at: new FormControl(),
    });

  }

  fetchListCustomer() {
    this.customerService.getAccountByCustomer().subscribe(data => {
      this.arraylist_customer = data.data;
      this.avatarUrl = data.data.image;
    })
    // this.subscription=this.customerService.getAll().subscribe(data => {
    //   this.list_customer = data.data;
    //   this.arraylist_customer = this.list_customer.filter(function (customer) {
    //     return customer.value === "KH";
    //   });
    //   this.avatarUrl = data.data.image;
    // },
    // err => {
    //     this.isLoading = false;
    //   })
  }
  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Th??m m???i th??ng tin kh??ch h??ng`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi ti???t th??ng tin kh??ch h??ng`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Ch???nh s???a th??ng tin kh??ch h??ng`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: accountModel, type = null): void {
    this.arrCheck = this.arraylist_customer;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    if (model.account_id === null || model.account_id === undefined) {
      this.formGroup = this.fb.group({
        full_name: [null, [Validators.required]],
        email: [null, [Validators.required]],
        address: [null, [Validators.required]],
        phone_number: [null, [Validators.required]],
        created_at: [this.datepipe.transform(Date.now(), 'shortDate')],
      });
      this.urlPictureDefault = avatarDefault;
    } else {
      this.formGroup = this.fb.group({
        full_name: [{ value: this.model.full_name, disabled: this.isInfo }, [Validators.required]],
        email: [{ value: this.model.email, disabled: this.isInfo }, [Validators.required]],
        address: [{ value: this.model.address, disabled: this.isInfo }, [Validators.required]],
        phone_number: [{ value: this.model.phone_number, disabled: this.isInfo }, [Validators.required]],
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
    let customer: accountModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
    this.toastr.error('Ki???m tra th??ng tin c??c tr?????ng ???? nh???p', 'www.tiendatcomputer.vn cho bi???t');;
      return;
    }
    if (this.isEdit) {
      customer = {
        full_name: this.formGroup.get('full_name')?.value,
        email: this.formGroup.get('email')?.value,
        address: this.formGroup.get('address')?.value,
        phone_number: this.formGroup.get('phone_number')?.value,
        image: this.urlPictureDefault,
      };
    } else {
      customer = {
        full_name: this.formGroup.get('full_name')?.value,
        email: this.formGroup.get('email')?.value,
        address: this.formGroup.get('address')?.value,
        phone_number: this.formGroup.get('phone_number')?.value,
        image: this.urlPictureDefault,
      };
    }
    if (this.isAdd) {
      this.customerService.create(customer).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho bi???t');
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho bi???t');
        }
      );
    }
    if (this.isEdit) {
      this.customerService.update(customer).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success("Ch???nh s???a th??nh c??ng","www.tiendatcomputer.vn cho bi???t");
        this.modalReference.dismiss();
      },
        err => {
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho bi???t');
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
    let path = `${file.name}`;
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
