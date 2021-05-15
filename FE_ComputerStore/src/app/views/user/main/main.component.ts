import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { newsModel } from '../../../models/news-model';
import { productModel } from '../../../models/product-model';
import { productTypeModel } from '../../../models/product-type-model';
import { NewsService } from '../../../services/news/news.service';
import { ProductTypeService } from '../../../services/product-type/product-type.service';
import { ProductService } from '../../../services/product/product.service';


@Component({
  selector: 'app-Main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {
  customOptions: any = {
    loop: true,
    mouseDrag: true,
    touchDrag: true,
    pullDrag: true,
    dots: true,
    navSpeed: 700,
    navText: ['', ''],
    responsive: {
      0: {
        items: 1
      },
      400: {
        items: 2
      },
      740: {
        items: 3
      },
      940: {
        items: 4
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
    private productTypeService : ProductTypeService
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
        if(item.amount === 0){
          item.check = "Liên hệ";   
        }
        else{
          item.check = "Còn hàng";
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
        if(item.amount === 0){
          item.check = "Liên hệ";   
        }
        else{
          item.check = "Còn hàng";
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
        if(item.amount == 0){
          item.check = "Liên hệ";
        }
        else{
          item.check = "Còn hàng";
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
        if(item.amount === 0){
          item.check = "Liên hệ";
        }
        else{
          item.check = "Còn hàng";
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
        if(item.amount === 0){
          item.check = "Liên hệ";
        }
        else{
          item.check = "Còn hàng";
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
        if(item.amount === 0){
          item.check = "Liên hệ";
        }
        else{
          item.check = "Còn hàng";
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
        if(item.amount === 0){
          item.check = "Liên hệ";
        }
        else{
          item.check = "Còn hàng";
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

  fetchProductRam(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_ram = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "RAM";
      });
      for(let item of this.list_product_ram){
        if(item.amount === 0){
          item.check = "Liên hệ";
        }
        else{
          item.check = "Còn hàng";
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
