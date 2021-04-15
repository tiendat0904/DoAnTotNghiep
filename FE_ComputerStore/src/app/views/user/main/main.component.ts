import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { productModel } from '../../../models/product-model';
import { ProductService } from '../../../services/product/product.service';

@Component({
  selector: 'app-Main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  list_product: Array<productModel> = [];
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
    private productService : ProductService
                          ) { }
 
  ngOnInit(): void {
    this.fetchProductLaptop();
    this.fetchProductRam();
    this.fetchProductMain();
    this.fetchProductPSU();
    this.fetchProductVGA();
    this.fetchProductCPU();
    this.fetchProductComputerComponent();
  }

  fetchProductPSU(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_psu = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "PSU";
      });
    },)
  }

  fetchProductLaptop(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_laptop = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "Laptop";
      });
    },)
  }

  fetchProductComputerComponent(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_computer_conponent = this.list_product.filter(function (laptop) {
        return (laptop.product_type_name === "Headphone" || laptop.product_type_name === "Mouse" || laptop.product_type_name === "Keyboard");
       
      });
    },)
  }

  fetchProductCPU(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_cpu = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "PSU";
      });
    },)
  }

  fetchProductVGA(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_vga = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "VGA";
      });
    },)
  }

  fetchProductMain(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_main = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "Main";
      });
    },)
  }

  fetchProductRam(){
    this.productService.getAll().subscribe(data => {
      this.list_product = data.data;
      this.list_product_ram = this.list_product.filter(function (laptop) {
        return laptop.product_type_name === "RAM";
      });
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
