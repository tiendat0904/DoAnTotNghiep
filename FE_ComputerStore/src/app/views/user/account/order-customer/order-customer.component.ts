import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { billModel } from '../../../../models/bill-model';
import { BillService } from '../../../../services/bill/bill.service';

@Component({
  selector: 'app-order-customer',
  templateUrl: './order-customer.component.html',
  styleUrls: ['./order-customer.component.scss']
})
export class OrderCustomerComponent implements OnInit {

  arraylist_bill: billModel[] = [];
  ischeck = false;
  ischeck1 = true;
  arraylist_bill_filter: billModel[] = [];
  constructor(private billService: BillService, private toastr: ToastrService, private router: Router) { }

  ngOnInit(): void {
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.arraylist_bill = data.data;
        this.arraylist_bill_filter = this.arraylist_bill.filter(function (bill) {
          return bill.customer_id === Number(localStorage.getItem("account_id"));
        })
        if (this.arraylist_bill_filter.length === 0) {
          this.ischeck = false;
          this.ischeck1 = true;
        } else {
          this.ischeck = true;
          this.ischeck1 = false;
        }
      }, err => {

      })
    } else {
      this.toastr.warning("Vui lòng đăng nhập để sử dụng dịch vụ");
      this.router.navigate(['/login']);
    }

  }

}
