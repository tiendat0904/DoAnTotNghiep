import { Component, OnInit } from '@angular/core';
import { ChartOptions, ChartType, ChartDataSets } from 'chart.js';
import { Label } from 'ng2-charts';
import { DatePipe } from '@angular/common';
import { BillService } from '../../../services/bill/bill.service';
import { billModel } from '../../../models/bill-model';
import { AccountService } from '../../../services/account/account.service';
import { accountModel } from '../../../models/account-model';
import { ProductService } from '../../../services/product/product.service';
import { productModel } from '../../../models/product-model';
import { trademarkModel } from '../../../models/trademark-model';
import { TrademarkService } from '../../../services/trademark/trademark.service';
import { LoaderService } from '../../../loader/loader.service';

@Component({
  templateUrl: 'dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

  array_date = [];
  array_amount = [];
  array_bill: billModel[] = [];
  array_customer: accountModel[] = [];
  array_product: productModel[] = [];
  array_trademark: trademarkModel[] = [];
  array_customer_filter: accountModel[] = [];
  customer_total: number;
  bill_total: number;
  trademark_total: number;
  product_total: number;
  page = 1;
  pageSize = 5;

  constructor(private datepipe: DatePipe,
    private billService: BillService,
    private customerService: AccountService,
    private productService: ProductService,
    private trademarkService: TrademarkService, public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.getListBill();
    this.getListCustomer();
    this.getListBrand();
    this.getListProduct();
  }

  barChartOptions: ChartOptions = {
    responsive: true,
    scales: {
      yAxes: [{
        ticks: {
          stepSize: 2
        }
      }]
    }

  };
  barChartLabels: Label[] = this.array_date;
  barChartType: ChartType = 'bar';
  barChartLegend = true;
  barChartPlugins = [];
  public chartColors: Array<any> = [
    {
      backgroundColor: 'rgba(0, 250, 220, .2)',
      borderColor: 'rgba(0, 213, 132, .7)',
      borderWidth: 2,
    }
  ];

  barChartData: ChartDataSets[] = [
    { data: this.array_amount, label: 'Số đơn hàng', }
  ];

  getListBill() {
    var amount = 0;
    var date = new Date();
    this.array_date.push(this.datepipe.transform(date, 'shortDate'));
    for (let i = 0; i < 14; i++) {
      date.setDate(date.getDate() - 1);
      this.array_date.push(this.datepipe.transform(date, 'shortDate'));
    }
    this.billService.getAll().subscribe(data => {
      this.array_bill = data.data;
      this.bill_total = this.array_bill.length;
      for (let date of this.array_date) {
        amount = 0;
        for (let bill of this.array_bill) {
          if (date === this.datepipe.transform(bill.created_at, 'shortDate')) {
            amount = amount + 1;
          }
        }
        this.array_amount.push(amount);
      }
    })
  }

  getListCustomer() {
    this.customerService.getAccountByCustomer().subscribe(data => {
      this.array_customer = data.data;
      this.customer_total = this.array_customer.length;
      this.array_customer.sort(function (a, b) {
        return b.account_id - a.account_id;
      });
    })
  }

  getListProduct() {
    this.productService.getAll().subscribe(data => {
      this.array_product = data.data;
      this.product_total = this.array_product.length;
    })
  }

  getListBrand() {
    this.trademarkService.getAll().subscribe(data => {
      this.array_trademark = data.data;
      this.trademark_total = this.array_trademark.length;
    })
  }
}
