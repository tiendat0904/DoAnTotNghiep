import { Component, OnDestroy, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { productModel } from '../../../models/product-model';
import { AccountService } from '../../../services/account/account.service';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../services/bill/bill.service';

@Component({
  selector: 'app-order-sucess',
  templateUrl: './order-sucess.component.html',
  styleUrls: ['./order-sucess.component.scss']
})
export class OrderSucessComponent implements OnInit,OnDestroy {

  update_customer_name: any;
  update_note: any;
  update_phone_number: any;
  array_product: Array<productModel> = [];
  array_product_filter:any;
  update_address: any;
  total_money: any;
  constructor( private accountService: AccountService,
    private router: Router,
    private billService:BillService,
    private toastr: ToastrService,
    private billDetailService:BillDetailService) { }
  ngOnDestroy(): void {
    // localStorage.removeItem("listProduct");
    // localStorage.removeItem("total_money");
  }

  ngOnInit(): void {
    // if(localStorage.getItem("account_id")){
    //   this.accountService.getInfo().subscribe(data => {
    //     this.update_customer_name = data.data.name;
    //     this.update_note = data.data.note;
    //     this.update_phone_number = data.data.phone_number;
    //     this.update_address = data.data.address;
    //   })
    // }else{
      this.billService.getBill().subscribe(data =>{
        this.update_customer_name = data.data.name;
        this.update_note = data.data.note;
        this.update_phone_number = data.data.phone_number;
        this.update_address = data.data.address;
        this.billDetailService.getbybill(data.data.bill_id).subscribe(data =>{
          this.array_product = data.data;
          console.log(this.array_product);
        });
        this.total_money = data.data.into_money;
      })
    // }
    
   

    // this.array_product = JSON.parse(localStorage.getItem('listProduct'));
    // for(let item of this.array_product_filter){
    //   this.array_product.push(item);
    // }
    
    
  }



}
