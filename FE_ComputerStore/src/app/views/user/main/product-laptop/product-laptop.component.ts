import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { productModel } from '../../../../models/product-model';
import { trademarkModel } from '../../../../models/trademark-model';
import { ProductService } from '../../../../services/product/product.service';
import { TrademarkService } from '../../../../services/trademark/trademark.service';

@Component({
  selector: 'app-product-laptop',
  templateUrl: './product-laptop.component.html',
  styleUrls: ['./product-laptop.component.scss']
})
export class ProductLaptopComponent implements OnInit {

  list_product: Array<productModel> = [];
  list_trademark: Array<trademarkModel> = [];
  list_trademark_selected: Array<trademarkModel> = [];
  list_trademark_show: Array<trademarkModel> = [];
  list_product_laptop = [];
  list_product_laptop1 = [];
  product_type_id :any;
  product_type_name: any;
  constructor(private productService : ProductService,private route :ActivatedRoute,private trademarkService : TrademarkService) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.product_type_id = Number.parseInt(params['product_type_id']);
    });
    this.fetchProduct();
  }

  fetchProduct(){
    this.productService.getAll().subscribe(data =>{
      let product_type = this.product_type_id;
      this.list_product = data.data;
      // this.product_type_name = data.data[0].product_type_name;
      this.list_product_laptop1=this.list_product_laptop = this.list_product.filter(function (laptop) {
        return (laptop.product_type_id === product_type);
      });
      this.product_type_name = this.list_product_laptop1[0].product_type_name;
    });
    
    this.trademarkService.getAll().subscribe(data =>{
      this.list_trademark = data.data;
      for(let item1 of this.list_trademark){
        for(let item2 of this.list_product_laptop){
          if(item1.trademark_id === item2.trademark_id){
            this.list_trademark_selected.push(item1);
          }
        }
        
      }
      this.list_trademark_show = this.list_trademark_selected.filter((test, index, array) =>
        index === array.findIndex((findTest) =>
            findTest.trademark_name === test.trademark_name
        ));
    })
   
  }

  public filterProducts(): void {
    this.list_product_laptop = this.list_product_laptop1;
    let list_product_filter = this.list_product_laptop;
    const activeColors = this.list_trademark_show.filter(c => c.selected).map(c => c.trademark_id);
    
    if(activeColors.length === 0 ){
      this.list_product_laptop = this.list_product_laptop1;

    }else{
      let list = list_product_filter.filter(product => activeColors.includes(product.trademark_id));
      this.list_product_laptop= [];
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
          return a.price - b.price;
        });
        // this.isLoading = false;
        break;
      case 3:
        // list = [...this.list_product_laptop];
        this.list_product_laptop.sort(function (a, b) {
          return b.price - a.price;
        });
        // this.isLoading = false;
        break;
      default:
        break;
    }
  }
  
}
