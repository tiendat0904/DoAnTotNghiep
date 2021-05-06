import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Toast, ToastrService } from 'ngx-toastr';
import { billDetailModel } from '../../../../models/bill-detail-model';
import { billModel } from '../../../../models/bill-model';
import { ItemModel } from '../../../../models/item-model';
import { productModel } from '../../../../models/product-model';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';
import { CartService } from '../../../../services/cart/cart.service';
import { ProductService } from '../../../../services/product/product.service';

@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.scss']
})
export class ProductDetailComponent implements OnInit {

  list_product: Array<productModel> = [];
  list_product_trademark_filter: Array<productModel> = [];
  list_product_trademark: Array<productModel> = [];
  product : productModel;
  billModel: billModel;
  billDetailModel: billDetailModel;
  list_bill: Array<billModel> = [];
  list_bill_detail: Array<billDetailModel> = [];
  list_item: Array<ItemModel> = [];
  descriptions: any;
  check:any;
  trademark_name : any;
  account_id: any;
  constructor(
    private route :ActivatedRoute,
    private productService : ProductService,
    private cartService: CartService,
    private billService: BillService,
    private toastr: ToastrService,
    private billDetailService: BillDetailService,
  ) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      let product_id = Number.parseInt(params['product_id']);
      this.productService.detail(product_id).subscribe(data =>{
        this.product = data.data;
        if(this.product.amount === 0){
          this.check= "Liên hệ";
        }
        else{
          this.check = "Còn hàng";
        }
        if(this.product.price_new === null){
          this.product.isCheckPrice = true;
          this.product.price_display = this.product.price;
        }else{
          this.product.isCheckPrice = false;
          this.product.price_display = this.product.price_new;
        }
        this.trademark_name = data.data.trademark_name;
        this.descriptions = this.product.description.split("\n");
        this.productService.getAll().subscribe(data => {
          this.list_product = data.data;
          let trademark_name_product = this.trademark_name;
          this.list_product_trademark_filter = this.list_product.filter(function (product) {
            return (product.trademark_name === trademark_name_product);
          });
          this.list_product_trademark = [];
          for(let item of this.list_product_trademark_filter){
            if(item.product_id === product_id){
            }else{
              if(item.price_new === null){
                item.isCheckPrice = true;
                item.price_display = item.price;
              }else{
                item.isCheckPrice = false;
                item.price_display = item.price_new;
              }
              this.list_product_trademark.push(item);
            }
          }
        },)
      });
      
    });
  }

  addProductToCart(){
    let product_detail = this.product;
    this.list_bill = [];
    this.list_bill_detail=[];
    let account_id = 0;
    let list_bill_filter = this.list_bill;
    let list_bill_detail_filter = this.list_bill_detail;
    if(product_detail.amount === 0){
      this.toastr.info("Sản phẩm đang hết hàng, vui lòng chọn sản phẩm khác !");
    }
    else{
      if(localStorage.getItem("account_id")){
        account_id = Number(localStorage.getItem("account_id"));
        this.billService.getAll().subscribe(data=>{
          this.list_bill = data.data;
          this.billDetailModel ={};
          list_bill_filter = this.list_bill.filter(function (bill) {
            return (bill.customer_id === account_id && bill.order_status_id === 1);         
          });
          if(list_bill_filter.length !== 0){
            this.billDetailService.getAll().subscribe(data=>{
              this.list_bill_detail = data.data;
              list_bill_detail_filter = this.list_bill_detail.filter(function (bill) {
                return (bill.bill_id === list_bill_filter[0].bill_id && bill.product_id === product_detail.product_id);         
              });
              if(list_bill_detail_filter.length === 0 ){
                this.billDetailModel = {
                  bill_id: list_bill_filter[0].bill_id,
                  product_id: product_detail.product_id,
                  price: product_detail.price_new,
                  amount: 1,
                }
                this.billDetailService.create(this.billDetailModel).subscribe(data => {
                });
              }else{
                this.billDetailModel = {
                  bill_detail_id:list_bill_detail_filter[0].bill_detail_id,
                  amount: list_bill_detail_filter[0].amount+1
                }
                this.billDetailService.update(list_bill_detail_filter[0].bill_detail_id,this.billDetailModel).subscribe(data=>{
                });
              }
            })           
          }else{
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
                    price: item.product.price_new,
                    amount: item.quantity,
                  }
                  this.billDetailService.create(this.billDetailModel).subscribe(data => {
                  });
                }
              }
            });
          }
        })
      }
      this.cartService.addToCart(this.product);
      this.toastr.success("Đã thêm sản phẩm vào giỏ hàng")
    }
    
  }
}
