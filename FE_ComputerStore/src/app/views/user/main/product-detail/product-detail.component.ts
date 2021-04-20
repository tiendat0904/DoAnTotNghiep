import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { productModel } from '../../../../models/product-model';
import { ProductService } from '../../../../services/product/product.service';

@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.scss']
})
export class ProductDetailComponent implements OnInit {

  list_product: Array<productModel> = [];
  list_product_trademark: Array<productModel> = [];
  product : productModel;
  descriptions: any;
  trademark_name : any;
  constructor(
    private route :ActivatedRoute,
    private productService : ProductService
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      let product_id = Number.parseInt(params['product_id']);
      this.productService.detail(product_id).subscribe(data =>{
        this.product = data.data;
        this.trademark_name = data.data.trademark_name;
        this.descriptions = this.product.description.split("\n");
      });
    });

    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      let trademark_name_product = this.trademark_name;
      this.list_product_trademark = this.list_product.filter(function (laptop) {
        return laptop.trademark_name === trademark_name_product;
      });
    },)
  }


  

}
