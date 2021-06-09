import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { accountModel } from '../../../../models/account-model';
import { billModel } from '../../../../models/bill-model';
import { AccountService } from '../../../../services/account/account.service';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';
import * as htmlToImage from 'html-to-image';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';

@Component({
  selector: 'app-print-order',
  templateUrl: './print-order.component.html',
  styleUrls: ['./print-order.component.scss']
})
export class PrintOrderComponent implements OnInit {

  arraylist_bill_detail: BillDetailService[] = [];
  order_id: any;
  order: billModel;
  customer: accountModel;
  page = 1;
  pageSize = 5;

  constructor(private route: ActivatedRoute,
    private billService: BillService,
    private billDetailService: BillDetailService,
    private router: Router,
    public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.order_id = Number.parseInt(params['bill_id']);
      this.getOrder();
    });
  }

  CaptureData(created_at: any, bill_id: any) {
    var data = document.getElementById("captureData");
    htmlToImage.toJpeg(data, { quality: 0.95 }).then(function (canvas) {
      const link: any = document.createElement("a");
      document.body.appendChild(link);
      link.download = "Bill" + created_at + bill_id + ".png";
      link.href = canvas;
      link.click();
    });
  }

  getNavigation(link, id) {
    if (id === '') {
      this.router.navigate([link]);
    } else {
      this.router.navigate([link + '/' + id]);
    }
  }

  getOrder() {
    this.billService.detail(this.order_id).subscribe(data => {
      this.order = data.data;
    })
    this.billDetailService.getbybill(this.order_id).subscribe(data => {
      this.arraylist_bill_detail = data.data;
    })
  }

}
