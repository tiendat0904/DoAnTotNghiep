import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Toast, ToastrService } from 'ngx-toastr';
import { avatarDefault } from '../../../../environments/environment';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { ItemModel } from '../../../models/item-model';
import { productModel } from '../../../models/product-model';
import { productTypeModel } from '../../../models/product-type-model';
import { trademarkModel } from '../../../models/trademark-model';
import { AccountService } from '../../../services/account/account.service';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { ProductTypeService } from '../../../services/product-type/product-type.service';
import { ProductService } from '../../../services/product/product.service';
import { TrademarkService } from '../../../services/trademark/trademark.service';
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
  list_product_type: Array<productTypeModel> = [];
  list_trademark: Array<trademarkModel> = [];
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
    private productTypeService: ProductTypeService,
    private productService: ProductService,
    private trademarkService: TrademarkService) { }


  ngOnInit(): void {
    this.renderTopMenu();
    this.fetchProductType();
    this.fetchProductTrademark();
  }


  getNavigation(link) {
    if (localStorage.getItem("account_id")) {
      this.router.navigate([link]);
    } else {
      this.toastr.warning("Vui l??ng ????ng nh???p ????? s??? d???ng d???ch v???", 'www.tiendatcomputer.vn cho bi???t');
    }
  }

  fetchProductType() {
    this.productTypeService.getAll().subscribe(data => {
      this.list_product_type = data.data;
    })
  }

  fetchProductTrademark() {
    this.trademarkService.getBrandHightlight().subscribe(data => {
      this.list_trademark = data.data;
    })
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
      this.toastr.warning("Vui l??ng nh???p s???n ph???m b???n mu???n t??m ki???m", 'www.tiendatcomputer.vn cho bi???t');
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
      for (let item of this.list_product) {
        if (item.price_new === null) {
          item.price_display = item.price;
        } else {
          item.price_display = item.price_new;
        }
      }
      if (this.searchedKeyword === null || this.searchedKeyword.length === 0) {
        this.check_search = true;
        this.list_product_filter = null;
      } else {
        this.check_search = false;
        this.list_product_filter = this.list_product;
        var keyword = this.searchedKeyword.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/??/g, 'd').replace(/??/g, 'D');
        this.list_product_filter.forEach(item => {
          var product_name = item.product_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/??/g, 'd').replace(/??/g, 'D');
          var product_type_name = item.product_type_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/??/g, 'd').replace(/??/g, 'D');
          var product_price = item.price_display.toString();
          if (product_name.includes(keyword) || product_type_name.includes(keyword) || product_price.includes(keyword)) {
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
      this.name = "????ng nh???p";
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

  renderTopMenu() {
    this.searchedKeyword = '';
    this.check_product = true;
    this.picture = this.urlPictureDefault;
    this.name = "????ng nh???p";
    this.url = "/#/login";
    var TopFixMenu = $(".header-main-center-scoll");
    TopFixMenu.hide();
    // d??ng s??? ki???n cu???n chu???t ????? b???t th??ng tin ???? cu???n ???????c chi???u d??i l?? bao nhi??u.
    $(window).scroll(function () {
      // N???u cu???n ???????c h??n 150px r???i
      if ($(this).scrollTop() > 300) {
        // Ti???n h??nh show menu ra   
        TopFixMenu.show();
      } else {
        // Ng?????c l???i, nh??? h??n 150px th?? hide menu ??i.
        TopFixMenu.hide();
      }
    }
    )
    $(document).ready(function () {
      $('.main-slider-left-scoll').hide();
      $('.danh-muc-san-pham').hover(
        function () {
          $('.main-slider-left-scoll').show();
        },
        function () {
          $('.main-slider-left-scoll').hide();
        }
      );
      $('.main-slider-left-scoll').hover(
        function () {
          $('.main-slider-left-scoll').show();
        },
        function () {
          $(this).hide();
        }
      )

      $('.brand-hover').hide();
      $('.header-main-brand').hover(
        function () {
          $('.brand-hover').show();
        },
        function () {
          $('.brand-hover').hide();
        }
      );
      $('.brand-hover').hover(
        function () {
          $('.brand-hover').show();
        },
        function () {
          $(this).hide();
        }
      )


      $('.main-slider-left-scoll1').hide();
      $('.danh-muc-san-pham1').hover(
        function () {
          $('.main-slider-left-scoll1').show();
        },
        function () {
          $('.main-slider-left-scoll1').hide();
        }
      )
    })
    $('.main-slider-left-scoll1').hover(
      function () {
        $('.main-slider-left-scoll1').show();
      },
      function () {
        $(this).hide();
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
    if (localStorage.getItem("account_id")) {
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
      this.name = "????ng nh???p";
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
  }


  onLogout() {
    localStorage.removeItem('Token');
    localStorage.clear();
    this.router.navigate(['/']);
  }

}
