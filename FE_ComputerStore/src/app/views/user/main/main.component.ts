import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { OwlOptions } from 'ngx-owl-carousel-o';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../loader/loader.service';
import { billDetailModel } from '../../../models/bill-detail-model';
import { billModel } from '../../../models/bill-model';
import { ItemModel } from '../../../models/item-model';
import { newsModel } from '../../../models/news-model';
import { productModel } from '../../../models/product-model';
import { productTypeModel } from '../../../models/product-type-model';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';
import { CartService } from '../../../services/cart/cart.service';
import { NewsService } from '../../../services/news/news.service';
import { ProductTypeService } from '../../../services/product-type/product-type.service';
import { ProductService } from '../../../services/product/product.service';
declare var $: any;

@Component({
  selector: 'app-Main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {
  customOptions: OwlOptions = {
    loop: true,
    mouseDrag: false,
    touchDrag: false,
    pullDrag: false,
    dots: false,
    navSpeed: 600,
    navText : ["<i class='fa fa-chevron-left'></i>","<i class='fa fa-chevron-right'></i>"],
    responsive: {
      0: {
        items: 1 
      },
      400: {
        items: 2
      },
      760: {
        items: 3
      },
      1000: {
        items: 5
      }
    },
    nav: true
  }



  list_news: Array<newsModel> = [];
  list_product_type: Array<productTypeModel> = [];
  list_product: Array<productModel> = [];
  list_product_new: Array<productModel> = [];
  list_product_psu: Array<productModel> = [];
  list_product_vga: Array<productModel> = [];
  list_product_computer_conponent: Array<productModel> = [];
  list_product_cpu: Array<productModel> = [];
  list_product_main: Array<productModel> = [];
  list_product_ram: Array<productModel> = [];
  list_product_laptop: Array<productModel> = [];
  images = ['https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fkhuyenmai-laptop.png?alt=media&token=6b12593e-de8e-4e34-abe1-4cffce35f4b7',
'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fbanner-2.jpg?alt=media&token=ba82fcab-0e61-4d8c-955a-31b94c164696',
'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fbanner1.png?alt=media&token=9a4aefcf-b032-4c11-b1a8-bfc77c9863d6',
'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fbanner4.png?alt=media&token=a1b70248-924a-4c9d-8595-7043c8d7cb18'];
  constructor(
    private router: Router,
    private productService : ProductService,
    private newService : NewsService,
    private productTypeService : ProductTypeService,
    private cartService: CartService,
    private toastr: ToastrService,
    private billDetailService: BillDetailService,
    private billService:BillService,
    public loaderService:LoaderService
                          ) { }
 
  ngOnInit(): void {
    // var refresh = window.localStorage.getItem('refresh');
  //   if(refresh===null){
  //     window.location.reload();
  //     window.localStorage.setItem('refresh', "1");
  // }
 
    this.fetchProductNew();
    this.fetchProductLaptop();
    this.fetchProductRam();
    this.fetchProductMain();
    this.fetchProductPSU();
    this.fetchProductVGA();
    this.fetchProductCPU();
    this.fetchProductComputerComponent();
    this.fetchNews();
    this.fetchProductType();
    
    // setTimeout(() => {{
    //   $('.checkContact').hide();
    //   $('.checkAmount').hover(
    //     function () {
    //       $('.checkContact').show();
    //     },
    //     function () {
    //       $('.checkContact').hide();
    //     }
    //   )
    // }
    // }, 3200);
    
  }

  fetchProductType(){
    this.productTypeService.getAll().subscribe(data => {
      this.list_product_type = data.data;
    },)
  }

  fetchNews(){
    this.newService.getAll().subscribe(data => {
      this.list_news = data.data;
    },)
  }

  fetchProductNew(){
    this.productService.getAll().subscribe(data =>{
      this.list_product_new = data.data;
      for(let item of this.list_product_new){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    })
  }

  fetchProductPSU(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_psu = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "PSU";
      });
      for(let item of this.list_product_psu){
        item.descriptions = item.description.split("\n");
        item.checkAmount = true;
        item.checkAmount = true;
        if (item.amount === 0) {
          item.check = "Liên hệ : 18001008";
          item.checkAmount = true;
        }
        else {
          item.check = "Còn hàng";
          item.checkAmount = false;
        }
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    },)
  }

  fetchProductLaptop(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_laptop = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "Laptop";
      });
      for(let item of this.list_product_laptop){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    },)
  }

  fetchProductComputerComponent(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_computer_conponent = this.list_product.filter(function (laptop) {
        return (laptop.product_type_name === "Headphone" || laptop.product_type_name === "Mouse" || laptop.product_type_name === "Keyboard");
       
      });
      for(let item of this.list_product_computer_conponent){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    },)
  }

  fetchProductCPU(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_cpu = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "CPU";
      });
      for(let item of this.list_product_cpu){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    },)
  }

  fetchProductVGA(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_vga = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "VGA";
      });
      for(let item of this.list_product_vga){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    },)
  }

  fetchProductMain(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_main = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "Main";
      });
      for(let item of this.list_product_main){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
        
      }
    },)
  }

  addProductToCart(product: productModel){
    let product_detail = product;
    let billDetailModel : billDetailModel;
    let billModel : billModel;
    let list_bill = [];
    let list_item: Array<ItemModel> = [];
    let list_bill_detail=[];
    let account_id = 0;
    let list_bill_filter = list_bill;
    let list_bill_detail_filter =  list_bill_detail;
      if(localStorage.getItem("account_id")){
        account_id = Number(localStorage.getItem("account_id"));
        this.billService.getAll().subscribe(data=>{
          list_bill = data.data;
          billDetailModel ={};
          list_bill_filter =list_bill.filter(function (bill) {
            return (bill.customer_id === account_id && bill.order_status_id === 1);         
          });
          if(list_bill_filter.length !== 0){
            this.billDetailService.getAll().subscribe(data=>{
               list_bill_detail = data.data;
              list_bill_detail_filter =  list_bill_detail.filter(function (bill) {
                return (bill.bill_id === list_bill_filter[0].bill_id && bill.product_id === product_detail.product_id);         
              });
              if(list_bill_detail_filter.length === 0 ){
                billDetailModel = {
                  bill_id: list_bill_filter[0].bill_id,
                  product_id: product_detail.product_id,
                  price: product_detail.price_display,
                  amount: 1,
                }
                this.billDetailService.create(billDetailModel).subscribe(data => {
                });
              }else{
                billDetailModel = {
                  bill_detail_id:list_bill_detail_filter[0].bill_detail_id,
                  amount: list_bill_detail_filter[0].amount+1
                }
                this.billDetailService.update(list_bill_detail_filter[0].bill_detail_id,billDetailModel).subscribe(data=>{
                });
              }
            })           
          }else{
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
      }
      this.cartService.addToCart(product);
      this.toastr.success("Đã thêm sản phẩm vào giỏ hàng")
  }

  fetchProductRam(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_ram = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "RAM";
      });
      for(let item of this.list_product_ram){
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
        if(item.price_new === null){
          item.isCheckPrice = true;
          item.price_display = item.price;
        }else{
          item.isCheckPrice = false;
          item.price_display = item.price_new;
        }
      }
    },)
  }
  
  

  getNavigation(link, id){
    if(id === ''){
        this.router.navigate([link]);
    } else {
        this.router.navigate([link + '/' + id]);
    }
  }

}
