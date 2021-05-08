import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Toast, ToastrService } from 'ngx-toastr';
import { avatarDefault } from '../../../../environments/environment';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { ItemModel } from '../../../models/item-model';
import { productModel } from '../../../models/product-model';
import { AccountService } from '../../../services/account/account.service';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { ProductService } from '../../../services/product/product.service';
declare var $: any;
@Component({
  selector: 'app-header1',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {

  url: any;
  name: any;
  account_id: any;
  check_bill: boolean;
  account_type_id: any;
  picture: any;
  urlPictureDefault = avatarDefault;
  list_bill: Array<billModel> = [];
  delay = ms => new Promise(res => setTimeout(res, ms));
  list_item: Array<ItemModel> = [];
  list_product: Array<productModel> = [];
  list_product_filter: Array<productModel> = [];
  billDetailModel: billDetailModel;
  billModel: billModel;
  searchedKeyword: string;
  check_product: boolean;
  check_search: boolean;
  // update_bill_id: any;
  constructor(
    private accountService: AccountService,
    private cartService: CartService,
    private billService: BillService,
    private billDetailService: BillDetailService,
    private toastr: ToastrService,
    private router: Router,
    private productService: ProductService) { }

  ngOnInit(): void {
    this.check_product = true;
    this.picture = this.urlPictureDefault;
    this.name = "Đăng nhập";
    this.url = "/#/login";
    var TopFixMenu = $(".header-main-center-scoll");
    TopFixMenu.hide();
    // dùng sự kiện cuộn chuột để bắt thông tin đã cuộn được chiều dài là bao nhiêu.
    $(window).scroll(function () {
      // Nếu cuộn được hơn 150px rồi
      if ($(this).scrollTop() > 200) {
        // Tiến hành show menu ra   
        TopFixMenu.show();
      } else {
        // Ngược lại, nhỏ hơn 150px thì hide menu đi.
        TopFixMenu.hide();
      }
    }
    )
   
    $('#header-hide1').hide();
    $('#header-account1').hover(
      function () {
        $('#header-hide1').hide();
      }
    )
    $('#header-hide').hide();
    $('#header-account').hover(
      function () {
        $('#header-hide').hide();
      }
    )
    this.fetchgetInfo();
    if (localStorage.length !== 0) {
      this.url = "/#/account/account-info";
      $(document).ready(function () {
        $('#header-account').hover(
          function () {
            $('#header-hide').show();
          },
          function () {
            $('#header-hide').hide();
          }
        )
        $('#header-hide').hover(
          function () {
            $('#header-hide').show();
          },
          function () {
            $(this).hide();
          }
        )

        $('#header-account1').hover(
          function () {
            $('#header-hide1').show();
          },
          function () {
            $('#header-hide1').hide();
          }
        )
        $('#header-hide1').hover(
          function () {
            $('#header-hide1').show();
          },
          function () {
            $(this).hide();
          }
        )
      })
    } else {
      this.url = "#/login";
      this.name = "Đăng nhập";
      $('#header-hide').hide();
      $('#header-account').hover(
        function () {
          $('#header-hide').hide();
        }
      )

      $('#header-hide1').hide();
      $('#header-account1').hover(
        function () {
          $('#header-hide1').hide();
        }
      )
    }
    if (this.name !== null) {
    }
    if (this.name) {
    }

  }



  redirectTo(uri: string) {
    this.router.navigateByUrl('/', { skipLocationChange: true }).then(() =>
      this.router.navigate([uri]));
  }

  public searchDetail() {
    this.searchedKeyword = null;
    this.list_product_filter = null;
  }

  public search() {
    if (this.searchedKeyword.length === 0) {
      this.toastr.warning("Vui lòng nhập sản phẩm bạn muốn tìm kiếm");
    } else {
      localStorage.setItem("search", this.searchedKeyword);
      this.searchedKeyword = null;
      this.list_product_filter = null;
      this.redirectTo('/search');
    }
  }



  public filterByKeyword() {
    var filterResult = [];
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      if (this.searchedKeyword === null || this.searchedKeyword.length === 0) {
        this.check_search = true;
        this.list_product_filter = null;
      } else {
        this.check_search = false;
        this.list_product_filter = this.list_product;
        var keyword = this.searchedKeyword.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
        this.list_product_filter.forEach(item => {
          var product_name = item.product_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
          var product_type_name = item.product_type_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
          if (product_name.includes(keyword) || product_type_name.includes(keyword)) {
            filterResult.push(item);
          }
        });
        if (filterResult.length === 0) {
          this.check_product = false;
          this.list_product_filter = null;
        } else {
          this.check_product = true;
          this.list_product_filter = filterResult;
        }
      }
    })

  }


  fetchgetInfo() {
    this.accountService.getInfo().subscribe(data => {
      this.name = data.data.full_name;
      if (data.image == null) {
        this.picture = this.urlPictureDefault;
      } else {
        this.picture = data.data.image;
      }
    }, error => {
      this.url = "#/login";
      this.name = "Đăng nhập";
      $('#header-hide').hide();
      $('#header-account').hover(
        function () {
          $('#header-hide').hide();
        },
        function () {
          $('#header-hide').hide();
        }
      )
    })
  }

  onLogout() {
    localStorage.removeItem('Token');
    localStorage.clear();
    this.router.navigate(['/']);
  }

}
