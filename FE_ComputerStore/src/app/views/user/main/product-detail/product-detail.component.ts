import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ActivatedRoute } from '@angular/router';
import { image } from 'html2canvas/dist/types/css/types/image';
import { Toast, ToastrService } from 'ngx-toastr';
import { isExternalModule } from 'typescript';
import { avatarDefault } from '../../../../../environments/environment';
import { LoaderService } from '../../../../loader/loader.service';
import { billDetailModel } from '../../../../models/bill-detail-model';
import { billModel } from '../../../../models/bill-model';
import { commentModel } from '../../../../models/commnent-model';
import { ItemModel } from '../../../../models/item-model';
import { productModel } from '../../../../models/product-model';
import { AccountService } from '../../../../services/account/account.service';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';
import { CartService } from '../../../../services/cart/cart.service';
import { CommentService } from '../../../../services/comment/comment.service';
import { ProductService } from '../../../../services/product/product.service';
declare var $: any;
@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.scss']
})
export class ProductDetailComponent implements OnInit {

  list_product: Array<productModel> = [];
  list_product_trademark_filter: Array<productModel> = [];
  list_product_trademark: Array<productModel> = [];
  product: productModel;
  billModel: billModel;
  billDetailModel: billDetailModel;
  list_bill: Array<billModel> = [];
  list_comment: Array<commentModel> = [];
  list_comment_noparent: Array<commentModel> = [];
  list_comment_rate: Array<commentModel> = [];
  list_comment_parent: Array<commentModel> = [];
  list_bill_detail: Array<billDetailModel> = [];
  list_item: Array<ItemModel> = [];
  descriptions: any;
  check: any;
  check_pagination: boolean;
  comment_content: any;
  comment_content1: any;
  comment_content_rate: any;
  trademark_name: any;
  account_id: any;
  checkRepComment: boolean;
  comment: commentModel;
  image_default: any;
  photos: any[];
  urlPictureDefault = avatarDefault;
  currentRate = 0;
  page = 1;
  pageSize = 3;

  constructor(
    private route: ActivatedRoute,
    private productService: ProductService,
    private cartService: CartService,
    private billService: BillService,
    private toastr: ToastrService,
    private billDetailService: BillDetailService,
    private commentService: CommentService,
    private accountService: AccountService,
    public loaderService: LoaderService,
    private titleService: Title
  ) { }

  ngOnInit(): void {
    this.checkRepComment = false;
    this.fetchProductDetail();
    this.fetchComment();
  }

  public setTitle(newTitle: string) {
    this.titleService.setTitle(newTitle);
  }

  fetchProductDetail() {
    let productview: productModel;
    this.route.params.subscribe(params => {
      let product_id = Number.parseInt(params['product_id']);
      this.productService.detail(product_id).subscribe(data => {
        this.setTitle(data.data.product_name);
        this.product = data.data;
        this.photos = data.data.image;
        if (this.product.amount === 0) {
          this.check = "Li??n h??? : 18001008";
        }
        else {
          this.check = "C??n h??ng";
        }
        if (this.product.price_new === null) {
          this.product.isCheckPrice = true;
          this.product.price_display = this.product.price;
        } else {
          this.product.isCheckPrice = false;
          this.product.price_display = this.product.price_new;
        }
        productview = {
          product_id: this.product.product_id,
          view: this.product.view + 1
        }
        this.productService.updateview(this.product.product_id, productview).subscribe();
        this.trademark_name = data.data.trademark_name;
        this.descriptions = this.product.description.split("\n");
        this.productService.getAll().subscribe(data => {
          this.list_product = data.data;
          let trademark_name_product = this.trademark_name;
          this.list_product_trademark_filter = this.list_product.filter(function (product) {
            return (product.trademark_name === trademark_name_product);
          });
          this.list_product_trademark = [];
          for (let item of this.list_product_trademark_filter) {
            if (item.product_id === product_id) {
            } else {
              item.descriptions = item.description.split("\n");
              item.checkAmount = true;
              if (item.amount === 0) {
                item.check = "Li??n h??? : 18001008";
                item.checkAmount = true;
              }
              else {
                item.check = "C??n h??ng";
                item.checkAmount = false;
              }
              if (item.price_new === null) {
                item.isCheckPrice = true;
                item.price_display = item.price;
              } else {
                item.isCheckPrice = false;
                item.price_display = item.price_new;
              }
              this.list_product_trademark.push(item);
            }
          }
        })
      });
    });
  }

  addProductToCart() {
    let product_detail = this.product;
    this.list_bill = [];
    this.list_bill_detail = [];
    let account_id = 0;
    let list_bill_filter = this.list_bill;
    let list_bill_detail_filter = this.list_bill_detail;
    if (product_detail.amount === 0) {
      this.toastr.info("S???n ph???m ??ang h???t h??ng, vui l??ng ch???n s???n ph???m kh??c !", 'www.tiendatcomputer.vn cho bi???t');
    }
    else {
      if (localStorage.getItem("account_id")) {
        account_id = Number(localStorage.getItem("account_id"));
        this.billService.getAll().subscribe(data => {
          this.list_bill = data.data;
          this.billDetailModel = {};
          list_bill_filter = this.list_bill.filter(function (bill) {
            return (bill.customer_id === account_id && bill.order_status_id === 1);
          });
          if (list_bill_filter.length !== 0) {
            this.billDetailModel = {
              bill_id: list_bill_filter[0].bill_id,
              product_id: product_detail.product_id,
              price: product_detail.price_display,
              amount: 1,
            }
            this.billDetailService.create(this.billDetailModel).subscribe(data => {
              this.toastr.success("???? th??m s???n ph???m v??o gi??? h??ng", 'www.tiendatcomputer.vn cho bi???t')
            },err =>{
              console.log(err.error.error)
              this.toastr.warning(err.error.error,'www.tiendatcomputer.vn cho bi???t');
            });
          } else {
            this.billModel = {
              customer_id: account_id,
            }
            this.billService.create(this.billModel).subscribe(data => {
              this.list_item = this.cartService.getItems();
              if (this.list_item !== null) {
                for (let item of this.list_item) {
                  this.billDetailModel = {
                    bill_id: data.data[0].bill_id,
                    product_id: item.product.product_id,
                    price: item.product.price_display,
                    amount: item.quantity,
                  }
                  this.billDetailService.create(this.billDetailModel).subscribe(data => {
                  });
                }
              }
            });
          }
        })
      }else{
        this.cartService.addToCart(this.product);
        this.toastr.success("???? th??m s???n ph???m v??o gi??? h??ng", 'www.tiendatcomputer.vn cho bi???t')
      } 
    }
  }

  fetchComment() {
   
    this.currentRate = 0;
    if (localStorage.getItem("account_id")) {
      this.accountService.getInfo().subscribe(data => {
        this.image_default = data.data.image;
      })
    } else {
      this.image_default = this.urlPictureDefault;
    }
    this.route.params.subscribe(params => {
      let product_id = Number.parseInt(params['product_id']);
      this.checkRepComment = false;
      this.list_comment_noparent = [];
      this.list_comment_rate = [];
      this.list_comment_parent = [];
      this.commentService.detail(product_id).subscribe(data => {
       
        this.list_comment = data.data;
        for (let item of this.list_comment) {
          if (item.status !== "??ang ch??? x??? l??") {
            if (item.rate === 0) {
              if (item.parentCommentId === null || item.parentCommentId === undefined) {
                this.list_comment_noparent.push(item);
              }
              else {
                this.list_comment_parent.push(item);
              }
            } else {
              this.list_comment_rate.push(item);
            }
          }
          if (this.list_comment_noparent.length === 0) {
            this.check_pagination = false;
          } else {
            this.check_pagination = true;
          }
          item.checkRepComment = true;
          if (item.image === '' || item.image === null || item.image === undefined) {
            item.image = this.urlPictureDefault;
          }
        }
        console.log(this.list_comment_noparent);
      })
    });
  }

  showCommentContent(comment_id) {
    this.checkRepComment = true;
    for (let comment of this.list_comment) {
      if (comment.comment_id === comment_id) {
        comment.checkRepComment = false;
      } else {
        comment.checkRepComment = true;
      }
    }
  }

  sendComment(parentCommentId: null, type: string) {
    switch (type) {
      case '1': {
        if (localStorage.getItem("account_id")) {
          if (this.comment_content === null || this.comment_content === undefined || this.comment_content === '') {
            this.toastr.warning("Vui l??ng nh???p n???i dung b??nh lu???n", 'www.tiendatcomputer.vn cho bi???t');
            return;
          }
          if (Number(localStorage.getItem("account_type_id")) === 3) {
            this.comment = {
              account_id: Number(localStorage.getItem("account_id")),
              product_id: this.product.product_id,
              comment_content: this.comment_content,
              status: "??ang ch??? x??? l??"
            }
          } else {
            this.comment = {
              account_id: Number(localStorage.getItem("account_id")),
              product_id: this.product.product_id,
              comment_content: this.comment_content,
              status: "???? x??c nh???n"
            }
          }

          this.commentService.create(this.comment).subscribe(data => {
            this.toastr.success(data.success, "www.tiendatcomputer.vn cho bi???t");
            this.comment_content = '';
            this.fetchComment();
          })
        } else {
          this.toastr.warning("vui l??ng ????ng nh???p ????? s??? d???ng d???ch v??? !", 'www.tiendatcomputer.vn cho bi???t');
        }
        break;
      }
      case '2': {
        console.log("ja");
        if (localStorage.getItem("account_id")) {
          if (this.comment_content1 === null || this.comment_content1 === undefined || this.comment_content1 === '') {
            this.toastr.warning("Vui l??ng nh???p n???i dung b??nh lu???n", 'www.tiendatcomputer.vn cho bi???t');
            return;
          }
          if (Number(localStorage.getItem("account_type_id")) === 3) {
            this.comment = {
              account_id: Number(localStorage.getItem("account_id")),
              product_id: this.product.product_id,
              comment_content: this.comment_content1,
              parentCommentId: parentCommentId,
              status: "??ang ch??? x??? l??"
            }
          } else {
            this.comment = {
              account_id: Number(localStorage.getItem("account_id")),
              product_id: this.product.product_id,
              comment_content: this.comment_content1,
              parentCommentId: parentCommentId,
              status: "???? x??c nh???n"
            }
          }
          this.commentService.create(this.comment).subscribe(data => {
            this.toastr.success(data.success, "www.tiendatcomputer.vn cho bi???t");
            this.comment_content1 = '';
            this.fetchComment();
          })
        } else {
          this.toastr.warning("vui l??ng ????ng nh???p ????? s??? d???ng d???ch v??? !", 'www.tiendatcomputer.vn cho bi???t');
        }
        break;
      }
      case '3': {
        console.log("ja222222");
        if (localStorage.getItem("account_id")) {
          if (this.comment_content_rate === null || this.comment_content_rate === undefined || this.comment_content_rate === '' || this.currentRate === 0) {
            this.toastr.warning("Vui l??ng nh???p n???i dung v?? ????nh gi?? s???n ph???m", 'www.tiendatcomputer.vn cho bi???t');
            return;
          }
          if (Number(localStorage.getItem("account_type_id")) === 3) {
            this.comment = {
              account_id: Number(localStorage.getItem("account_id")),
              product_id: this.product.product_id,
              comment_content: this.comment_content_rate,
              rate: this.currentRate,
              status: "??ang ch??? x??? l??"
            }
          } else {
            this.comment = {
              account_id: Number(localStorage.getItem("account_id")),
              product_id: this.product.product_id,
              comment_content: this.comment_content_rate,
              rate: this.currentRate,
              status: "???? x??c nh???n"
            }
          }
          this.commentService.create(this.comment).subscribe(data => {
            this.toastr.success(data.success, "www.tiendatcomputer.vn cho bi???t");
            this.comment_content_rate = '';
            this.fetchComment();
          })
        } else {
          this.toastr.warning("vui l??ng ????ng nh???p ????? s??? d???ng d???ch v??? !", 'www.tiendatcomputer.vn cho bi???t');
        }
      }
        break;
    }
  }
}
