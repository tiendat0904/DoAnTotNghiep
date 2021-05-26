import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { commentModel } from '../../../../models/commnent-model';
import { CommentService } from '../../../../services/comment/comment.service';
import { UpdateCommentCustomerComponent } from '../update-comment-customer/update-comment-customer.component';

@Component({
  selector: 'app-comment-customer',
  templateUrl: './comment-customer.component.html',
  styleUrls: ['./comment-customer.component.scss']
})
export class CommentCustomerComponent implements OnInit {

  @ViewChild(UpdateCommentCustomerComponent) view!: UpdateCommentCustomerComponent;
  list_comment: Array<commentModel> = [];
  listFilterResult: commentModel[] = [];
  filterResultTemplist: commentModel[] = [];
  modalReference: any;
  condition = true;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  // isSelected = true;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private commentService: CommentService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.searchedKeyword = '';
    this.fetchListSupplier();
  }

  fetchListSupplier() {
    this.isLoading = true;
    this.commentService.getAll().subscribe(data => {
      this.list_comment = data.data;
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
        var dc = item.full_name.toLowerCase();
        var ten = item.created_at.toDateString();
        if (dc.includes(keyword) || ten.includes(keyword)) {
          filterResult.push(item);
        }
      });
      this.listFilterResult = filterResult;
      if(this.listFilterResult.length !== 0){
        this.condition = true;
      }else{
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
      .filter((comment) => comment.checked)
      .map((p) => p.comment_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;
    } else {
      this.isDelete = true;
    }
  }

  deleteComment(item: any = null) {
    let selectedcomment = [];
    if (item !== null && item !== undefined && item !== '') {
      selectedcomment.push(item);
      this.delete(selectedcomment);
      return;
    }
    selectedcomment = this.listFilterResult
      .filter((comment) => comment.checked)
      .map((p) => p.comment_id);
    if (selectedcomment.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectedcomment);
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
    this.commentService.delete(modelDelete).subscribe(
      (result) => {
        this.modalReference.dismiss();
        this.fetchListSupplier();
        this.changeModel();
        if (result.error) {
          this.toastr.error(result.error);
        } else {
          console.log(result.success)
          this.toastr.success(result.success);
        }
      },
    );
  }

}
