import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { accountModel } from '../../../../models/account-model';
import { billModel } from '../../../../models/bill-model';
import { AccountService } from '../../../../services/account/account.service';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';

@Component({
  selector: 'app-order-detail-customer',
  templateUrl: './order-detail-customer.component.html',
  styleUrls: ['./order-detail-customer.component.scss']
})
export class OrderDetailCustomerComponent implements OnInit {

  order_id:any;
  order:billModel;
  customer:accountModel;
  page = 1;
  pageSize = 5;
  arraylist_bill_detail: BillDetailService[] = [];
  constructor(private route: ActivatedRoute,private billService:BillService,private billDetailService:BillDetailService,private customerService:AccountService) { }


  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.order_id = Number.parseInt(params['bill_id']);
      this.getOrder();
    });
    
  }

  getOrder(){
    this.billService.detail(this.order_id).subscribe(data =>{
      this.order = data.data;
      console.log(this.order);
    })

    this.billDetailService.getbybill(this.order_id).subscribe(data => {
      this.arraylist_bill_detail = data.data;
    })

    this.customerService.getInfo().subscribe(data=>{
      this.customer = data.data;
    })
  }

}
