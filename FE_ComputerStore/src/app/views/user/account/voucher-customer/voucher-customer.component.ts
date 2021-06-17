import { Component, OnInit } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { voucherCustomerModel } from '../../../../models/voucher-customer-model';
import { VoucherCustomerServiceService } from '../../../../services/voucher-customer-service/voucher-customer-service.service';

@Component({
  selector: 'app-voucher-customer',
  templateUrl: './voucher-customer.component.html',
  styleUrls: ['./voucher-customer.component.scss']
})
export class VoucherCustomerComponent implements OnInit {

  arraylist_voucher: voucherCustomerModel[] = [];
  arraylist_voucher_filter: voucherCustomerModel[] = [];
  ischeck = false;
  ischeck1 = true;

  constructor(
    private voucherService: VoucherCustomerServiceService,
    private toastr: ToastrService,
    private router: Router,
    private titleService: Title,
    public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.fetchOrderCustomer();
  }

  fetchOrderCustomer() {
    this.titleService.setTitle("Ví voucher");
    if (localStorage.getItem("account_id")) {
      this.voucherService.detail(localStorage.getItem("account_id")).subscribe(data => {
        this.arraylist_voucher_filter = data.data;
        if (this.arraylist_voucher_filter.length === 0) {
          this.ischeck = false;
          this.ischeck1 = true;
        } else {
          this.ischeck = true;
          this.ischeck1 = false;
        }
      })
    } else {
      this.toastr.warning("Vui lòng đăng nhập để sử dụng dịch vụ",'www.tiendatcomputer.vn cho biết');
    }
  }

}
