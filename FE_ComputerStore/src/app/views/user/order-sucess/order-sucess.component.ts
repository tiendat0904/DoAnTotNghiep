import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { productModel } from '../../../models/product-model';
import { AccountService } from '../../../services/account/account.service';

@Component({
  selector: 'app-order-sucess',
  templateUrl: './order-sucess.component.html',
  styleUrls: ['./order-sucess.component.scss']
})
export class OrderSucessComponent implements OnInit,OnDestroy {

  update_customer_name: any;
  update_email: any;
  update_phone_number: any;
  array_product: Array<productModel> = [];
  array_product_filter:any;
  update_address: any;
  total_money: any;
  constructor( private accountService: AccountService,
    private router: Router,
    private toastr: ToastrService) { }
  ngOnDestroy(): void {
    localStorage.removeItem("listProduct");
    localStorage.removeItem("total_money");
  }

  ngOnInit(): void {
    this.accountService.getInfo().subscribe(data => {
      this.update_customer_name = data.data.full_name;
      this.update_email = data.data.email;
      this.update_phone_number = data.data.phone_number;
      this.update_address = data.data.address;
    })

    this.array_product = JSON.parse(localStorage.getItem('listProduct'));
    // for(let item of this.array_product_filter){
    //   this.array_product.push(item);
    // }
    console.log(this.array_product);
    this.total_money = localStorage.getItem("total_money");
  }



}
