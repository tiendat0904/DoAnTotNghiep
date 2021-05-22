import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { newsModel } from '../../../../models/news-model';
import { NewsService } from '../../../../services/news/news.service';
import { UpdateNewsComponent } from '../update-news/update-news.component';

@Component({
  selector: 'app-news',
  templateUrl: './news.component.html',
  styleUrls: ['./news.component.scss']
})
export class NewsComponent implements OnInit {

  @ViewChild(UpdateNewsComponent) view!: UpdateNewsComponent;
  arraylist_news: Array<newsModel> = [];
  filterResultTemplist: newsModel[] = [];
  listFilterResult: newsModel[] = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  searchedKeyword: string;
  page = 1;
  pageSize = 5;

  constructor(
    private modalService: NgbModal,
    private newsService: NewsService,
    private toastr: ToastrService,
    public loaderService: LoaderService
  ) { }

  ngOnInit(): void {
    this.fetchListNews();
  }

  fetchListNews() {
    this.newsService.getAll().subscribe(data => {
      this.arraylist_news = data.data;
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
        var dc = item.title.toLowerCase();
        var hot_line = item.url.toLowerCase();
        if (dc.includes(keyword) || hot_line.includes(keyword)) {
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
      .filter((news) => news.checked)
      .map((p) => p.news_id);
    if (selectedHometowns.length > 0) {
      this.isDelete = false;
    } else {
      this.isDelete = true;
    }
  }

  deleteNews(item: any = null) {
    let selectednews = [];
    if (item !== null && item !== undefined && item !== '') {
      selectednews.push(item);
      this.delete(selectednews);
      return;
    }
    selectednews = this.listFilterResult
      .filter((news) => news.checked)
      .map((p) => p.news_id);
    if (selectednews.length === 0) {
      this.toastr.error('Chọn ít nhất một bản ghi để xóa.');
      return;
    }
    this.delete(selectednews);
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

    this.newsService.delete(modelDelete).subscribe(
      (result) => {
        this.fetchListNews();
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
