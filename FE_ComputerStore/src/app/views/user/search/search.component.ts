import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { productModel } from '../../../models/product-model';
import { trademarkModel } from '../../../models/trademark-model';
import { ProductService } from '../../../services/product/product.service';
import { TrademarkService } from '../../../services/trademark/trademark.service';

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
  product_type_id: any;
  product_type_name: any;
  constructor(private productService: ProductService, private route: ActivatedRoute, private trademarkService: TrademarkService) { }

  ngOnInit(): void {
    this.search = localStorage.getItem("search");
    this.fetchProduct();

  }

  ngOnDestroy(): void {
    this.list_product_laptop = null;
  }

  fetchProduct() {
    var filterResult = [];
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
      });
    });
  }

  public filterProducts(): void {
    this.list_product_laptop = this.list_product_laptop1;
    let list_product_filter = this.list_product_laptop;
    const activeColors = this.list_trademark_show.filter(c => c.selected).map(c => c.trademark_id);

    if (activeColors.length === 0) {
      this.list_product_laptop = this.list_product_laptop1;

    } else {
      let list = list_product_filter.filter(product => activeColors.includes(product.trademark_id));
      this.list_product_laptop = [];
      this.list_product_laptop = list;

    }
  }
  changeStatus(event: any) {
    // this.isLoading = true;
    // let list = [];
    // tslint:disable-next-line: radix
    switch (parseInt(event)) {
      case 0:
        this.list_product_laptop = [...this.list_product_laptop];
        // this.isLoading = false;
        break;
      case 1:
        // list = [...this.list_product_laptop];
        this.list_product_laptop.sort(function (a, b) {
          return b.product_id - a.product_id;
        });
        // this.isLoading = false;
        break;
      case 2:
        // list = [...this.list_product_laptop];
        this.list_product_laptop.sort(function (a, b) {
          return b.price - a.price;
        });
        // this.isLoading = false;
        break;
      case 3:
        // list = [...this.list_product_laptop];
        this.list_product_laptop.sort(function (a, b) {
          return a.price - b.price;
        });

        // this.isLoading = false;
        break;
      default:
        break;
    }
  }


}