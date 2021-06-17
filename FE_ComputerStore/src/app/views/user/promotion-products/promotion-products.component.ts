import { Options } from '@angular-slider/ngx-slider';
import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { ActivatedRoute } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../loader/loader.service';
import { ItemModel } from '../../../models/item-model';
import { productModel } from '../../../models/product-model';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { trademarkModel } from '../../../models/trademark-model';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { ProductService } from '../../../services/product/product.service';
import { TrademarkService } from '../../../services/trademark/trademark.service';

@Component({
  selector: 'app-promotion-products',
  templateUrl: './promotion-products.component.html',
  styleUrls: ['./promotion-products.component.scss']
})
export class PromotionProductsComponent implements OnInit {

  list_product: Array<productModel> = [];
  list_trademark: Array<trademarkModel> = [];
  list_trademark_selected: Array<trademarkModel> = [];
  list_trademark_show: Array<trademarkModel> = [];
  list_product_laptop = [];
  list_product_laptop1: Array<productModel> = [];
  isCheckPrice: boolean;
  checkSelect: any;
  product_type_id: any;
  product_type_name: any;
  price_new: any;
  page = 1;
  pageSize = 12;
  minValue: number = 0;
  maxValue: number = 100000000;
  options: Options = {
    floor: 0,
    ceil: 100000000,
    step: 500000
  };

  constructor(private productService: ProductService, private route: ActivatedRoute, private trademarkService: TrademarkService,
    private cartService: CartService,
    private toastr: ToastrService,
    private billDetailService: BillDetailService,
    private billService: BillService,
    private titleService: Title,
    public loaderService: LoaderService) { }


  ngOnInit(): void {
      this.fetchProduct();
  }

  public setTitle(newTitle: string) {
    this.titleService.setTitle(newTitle);
  }

  fetchProduct() {
    this.checkSelect = 0;
    this.list_product_laptop = [];
    this.list_trademark_show = [];
    this.list_product_laptop1 = [];
    this.list_trademark_selected = [];
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_laptop1 = this.list_product_laptop = this.list_product.filter(function (laptop) {
        return (laptop.price_new !== null);
      });
      
      this.product_type_name = this.list_product_laptop1[0].product_type_name;
      this.trademarkService.getAll().subscribe(data => {
        this.list_trademark = data.data;
        for (let item1 of this.list_trademark) {
          for (let item2 of this.list_product_laptop) {
            item2.descriptions = item2.description.split("\n");
            item2.checkAmount = true;
            if (item2.amount === 0) {
              item2.check = "Liên hệ : 18001008";
              item2.checkAmount = true;
            }
            else {
              item2.check = "Còn hàng";
              item2.checkAmount = false;
            }
            if (item2.price_new === null) {
              item2.isCheckPrice = true;
              item2.price_display = item2.price;
            } else {
              item2.isCheckPrice = false;
              item2.price_display = item2.price_new;
            }
            if (item1.trademark_id === item2.trademark_id) {
              this.list_trademark_selected.push(item1);
            }
          }
        }
        this.list_trademark_show = this.list_trademark_selected.filter((test, index, array) =>
          index === array.findIndex((findTest) =>
            findTest.trademark_name === test.trademark_name
          ));
      })
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
          // this.billDetailService.getAll().subscribe(data => {
          //   list_bill_detail = data.data;
          //   list_bill_detail_filter = list_bill_detail.filter(function (bill) {
          //     return (bill.bill_id === list_bill_filter[0].bill_id && bill.product_id === product_detail.product_id);
          //   });
          //   if (list_bill_detail_filter.length === 0) {
          //     billDetailModel = {
          //       bill_id: list_bill_filter[0].bill_id,
          //       product_id: product_detail.product_id,
          //       price: product_detail.price_display,
          //       amount: 1,
          //     }
          //     this.billDetailService.create(billDetailModel).subscribe(data => {
          //     });
          //   } else {
          //     billDetailModel = {
          //       bill_detail_id: list_bill_detail_filter[0].bill_detail_id,
          //       amount: list_bill_detail_filter[0].amount + 1
          //     }
          //     this.billDetailService.update(list_bill_detail_filter[0].bill_detail_id, billDetailModel).subscribe(data => {
          //     });
          //   }
          // })
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
    this.minValue = 0;
    this.maxValue = 100000000;
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

  filterPrice() {
    if (this.checkSelect !== 0) {
      this.checkSelect = 0;
    }
    for (let item of this.list_trademark_show) {
      item.selected = false;
    }
    let list_product_filter = this.list_product_laptop1;
    let list = list_product_filter.filter(product => product.price_display < this.maxValue && product.price_display > this.minValue);
    // this.list_product_laptop = [];
    this.list_product_laptop = list;
  }

  changeStatus(event: any) {
    this.minValue = 0;
    this.maxValue = 100000000;
    for (let item of this.list_trademark_show) {
      item.selected = false;
    }
    this.list_product_laptop = this.list_product_laptop1;
    switch (parseInt(event)) {
      case 0:
        this.list_product_laptop = [...this.list_product_laptop1];
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
      case 4:
        this.list_product_laptop.sort(function (a, b) {
          return b.view - a.view;
        });
        break;
      case 5:
        this.list_product_laptop.sort(function (a, b) {
          return b.rate - a.rate;
        });
        break;
      default:
        break;
    }
  }

}
