import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'angular-bootstrap-md';
import { ToastrService } from 'ngx-toastr';
import { Observable, Subscription } from 'rxjs';
import { accountModel } from '../../../../models/account-model';
import { accountTypeModel } from '../../../../models/account-type-model';
import { commentModel } from '../../../../models/commnent-model';
import { AccountTypeService } from '../../../../services/account-type/account-type.service';
import { AccountService } from '../../../../services/account/account.service';
import { CommentService } from '../../../../services/comment/comment.service';

@Component({
  selector: 'app-update-comment-customer',
  templateUrl: './update-comment-customer.component.html',
  styleUrls: ['./update-comment-customer.component.scss']
})
export class UpdateCommentCustomerComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_comment: Array<commentModel>;
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
  comment_rate = 0;
  submitted = false;
  title = '';
  type: any;
  status_comment :any;
  arrCheck = [];
  model: commentModel;

  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private commentService: CommentService
  ) { }

  ngOnInit(): void {
    this.submitted = false;
    this.fetchListComment();
  }

  fetchListComment() {
    this.subscription = this.commentService.getAll().subscribe(data => {
      this.arraylist_comment = data.data;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Thêm mới thông tin comment`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi tiết thông tin comment`;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Chỉnh sửa thông tin comment`;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  view(model: commentModel, type = null): void {
    this.arrCheck = this.arraylist_comment;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
    this.comment_rate = model.rate;
    if (model.comment_id === null || model.comment_id === undefined) {
      // this.formGroup = this.fb.group({
      //   ten: [null, [Validators.required]],
      //   dia_chi: [null, [Validators.required]],
      //   hot_line: [null, [Validators.required]],
      //   email: [null, [Validators.required, Validators.pattern(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i)]],
      // });
    } else {
      this.formGroup = this.fb.group({
        full_name: [{ value: this.model.full_name, disabled: this.isInfo }, [Validators.required]],
        description: [{ value: this.model.description, disabled: this.isInfo }, [Validators.required]],
        comment_content: [{ value: this.model.comment_content, disabled: this.isInfo }, [Validators.required]],
        status: [{ value: this.model.status, disabled: this.isInfo }, [Validators.required]],
      });
    }
    console.log(this.formGroup)
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
    let comment: commentModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
      this.toastr.error('Kiểm tra thông tin các trường đã nhập');
      return;
    }
    if (this.isEdit) {
      comment = {
        comment_id: this.model.comment_id,
        comment_content: this.formGroup.get('comment_content')?.value,
        status: this.formGroup.get('status')?.value,
      };

    } else {
      // comment = {
      //   comment_id: this.model.comment_id,
      //   comment_name: this.formGroup.get('ten')?.value,
      //   comment_address: this.formGroup.get('dia_chi')?.value,
      //   hotline: this.formGroup.get('hot_line')?.value,
      //   email: this.formGroup.get('email')?.value,
      // };
    }
    if (this.isEdit) {
      this.commentService.update(comment.comment_id, comment).subscribe(res => {
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
