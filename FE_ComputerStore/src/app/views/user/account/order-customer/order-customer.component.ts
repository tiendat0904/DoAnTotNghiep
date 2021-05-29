import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { billModel } from '../../../../models/bill-model';
import { BillService } from '../../../../services/bill/bill.service';

@Component({
  selector: 'app-order-customer',
  templateUrl: './order-customer.component.html',
  styleUrls: ['./order-customer.component.scss']
})
export class OrderCustomerComponent implements OnInit {

  arraylist_bill: billModel[] = [];
  arraylist_bill_filter: billModel[] = [];
  ischeck = false;
  ischeck1 = true;

  constructor(
    private billService: BillService,
    private toastr: ToastrService,
    private router: Router,
    public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.fetchOrderCustomer();
  }

  fetchOrderCustomer() {
    if (localStorage.getItem("account_id")) {
      this.billService.getAll().subscribe(data => {
        this.arraylist_bill = data.data;
        this.arraylist_bill_filter = this.arraylist_bill.filter(function (bill) {
          return (bill.customer_id === Number(localStorage.getItem("account_id")) && bill.order_status_id !== 1);
        })
        if (this.arraylist_bill_filter.length === 0) {
          this.ischeck = false;
          this.ischeck1 = true;
        } else {
          this.ischeck = true;
          this.ischeck1 = false;
        }
      })
    } else {
      this.toastr.warning("Vui lòng đăng nhập để sử dụng dịch vụ",'www.tiendatcomputer.vn cho biết');
      this.router.navigate(['/login']);
    }
  }
}
