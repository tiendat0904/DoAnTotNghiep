import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../loader/loader.service';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { ItemModel } from '../../../models/item-model';
import { productModel } from '../../../models/product-model';
import { trademarkModel } from '../../../models/trademark-model';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { ProductService } from '../../../services/product/product.service';
import { TrademarkService } from '../../../services/trademark/trademark.service';
declare var $: any;

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss']
})
export class SearchComponent implements OnInit, OnDestroy {

  list_product: Array<productModel> = [];
  list_trademark: Array<trademarkModel> = [];
  list_trademark_selected: Array<trademarkModel> = [];
  list_trademark_show: Array<trademarkModel> = [];
  list_product_laptop = [];
  list_product_laptop1 = [];
  search: string;
  checkSelect: any;
  product_type_id: any;
  product_type_name: any;
  page = 1;
  pageSize = 16;

  constructor(private productService: ProductService,
    private route: ActivatedRoute,
    private trademarkService: TrademarkService,
    private cartService: CartService,
    private toastr: ToastrService,
    private billDetailService: BillDetailService,
    private billService: BillService, public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.search = localStorage.getItem("search");
    this.fetchProduct();

  }

  ngOnDestroy(): void {
    this.list_product_laptop = null;
  }

  fetchProduct() {
    var filterResult = [];
    this.checkSelect = 0;
    this.list_product_laptop = [];
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      var keyword = this.search.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
      this.list_product.forEach(item => {
        var name = item.product_name.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
        if (name.includes(keyword)) {
          filterResult.push(item);
        }
        if (filterResult.length === 0) {
        } else {
          this.list_product_laptop = this.list_product_laptop1 = filterResult;
        }
      });
      this.trademarkService.getAll().subscribe(data => {
        this.list_trademark = data.data;
        if (this.list_product_laptop !== null) {
          for (let item1 of this.list_trademark) {
            for (let item2 of this.list_product_laptop) {
              if (item1.trademark_id === item2.trademark_id) {
                this.list_trademark_selected.push(item1);
              }
            }
          }
          this.list_trademark_show = this.list_trademark_selected.filter((test, index, array) =>
            index === array.findIndex((findTest) =>
              findTest.trademark_name === test.trademark_name
            ));
        }
      })
      for (let item of this.list_product_laptop) {
        item.descriptions = item.description.split("\n");
        item.checkAmount = true;
        if (item.amount === 0) {
          item.check = "Liên hệ : 18001008";
          item.checkAmount = true;
        }
        else {
          item.check = "Còn hàng";
          item.checkAmount = false;
        }
        if (item.price_new === null) {
          item.isCheckPrice = true;
          item.price_display = item.price;
        } else {
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    });
  }

  addProductToCart(product: productModel) {
    let product_detail = product;
    let billDetailModel: billDetailModel;
    let billModel: billModel;
    let list_bill = [];
    let list_item: Array<ItemModel> = [];
    let list_bill_detail = [];
    let account_id = 0;
    let list_bill_filter = list_bill;
    let list_bill_detail_filter = list_bill_detail;
    if (localStorage.getItem("account_id")) {
      account_id = Number(localStorage.getItem("account_id"));
      this.billService.getAll().subscribe(data => {
        list_bill = data.data;
        billDetailModel = {};
        list_bill_filter = list_bill.filter(function (bill) {
          return (bill.customer_id === account_id && bill.order_status_id === 1);
        });
        if (list_bill_filter.length !== 0) {
          billDetailModel = {
            bill_id: list_bill_filter[0].bill_id,
            product_id: product_detail.product_id,
            price: product_detail.price_display,
            amount: 1,
          }
          this.billDetailService.create(billDetailModel).subscribe(data => {
            this.toastr.success("Đã thêm sản phẩm vào giỏ hàng", 'www.tiendatcomputer.vn cho biết')
          }, err => {
            console.log(err.error.error)
            this.toastr.warning(err.error.error, 'www.tiendatcomputer.vn cho biết');
          });
        } else {
          billModel = {
            customer_id: account_id,
          }
          this.billService.create(billModel).subscribe(data => {
            list_item = this.cartService.getItems();
            if (list_item !== null) {
              for (let item of list_item) {
                billDetailModel = {
                  bill_id: data.data[0].bill_id,
                  product_id: item.product.product_id,
                  price: item.product.price_display,
                  amount: item.quantity,
                }
                this.billDetailService.create(billDetailModel).subscribe(data => {
                });
              }
            }
          });
        }
      })
    } else {
      this.cartService.addToCart(product);
      this.toastr.success("Đã thêm sản phẩm vào giỏ hàng", 'www.tiendatcomputer.vn cho biết')
    }

  }

  public filterProducts(): void {
    if (this.checkSelect !== 0) {
      this.checkSelect = 0;
    }
    // this.list_product_laptop = this.list_product_laptop1;
    let list_product_filter = this.list_product_laptop1;
    const activeColors = this.list_trademark_show.filter(c => c.selected).map(c => c.trademark_id);

    if (activeColors.length === 0) {
      this.list_product_laptop = this.list_product_laptop1;
    } else {
      let list = list_product_filter.filter(product => activeColors.includes(product.trademark_id));
      // this.list_product_laptop = [];
      this.list_product_laptop = list;

    }
  }

  changeStatus(event: any) {
    for (let item of this.list_trademark_show) {
      item.selected = false;
    }
    switch (parseInt(event)) {
      case 0:
        this.list_product_laptop = [...this.list_product_laptop];
        break;
      case 1:
        this.list_product_laptop.sort(function (a, b) {
          return b.product_id - a.product_id;
        });
        break;
      case 2:
        this.list_product_laptop.sort(function (a, b) {
          return b.price - a.price;
        });
        break;
      case 3:
        this.list_product_laptop.sort(function (a, b) {
          return a.price - b.price;
        });
        break;
      default:
        break;
    }
  }
}
