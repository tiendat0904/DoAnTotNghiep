import { Component, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { couponReportModel } from '../../../../models/coupon-report-model';
import { excelModel } from '../../../../models/excel-model';
import { ExcelService } from '../../../../services/excel/excel.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-coupon-report',
  templateUrl: './coupon-report.component.html',
  styleUrls: ['./coupon-report.component.scss']
})
export class CouponReportComponent implements OnInit {

  arraylist_coupon: Array<couponReportModel> = [];
  model : excelModel;
  modalReference: any;
  ismonth = true;
  isQuarter = true;
  isyear = true;
  closeResult: string;
  isLoading = false;
  searchedKeyword: string;
  filterResultTemplist: couponReportModel[] = [];
  isSelected = true;
  page = 1;
  label: any;
  label1: any;
  label2: any;
  pageSize = 5;
  update: any;
  update1: any;
  update2: [2018,2019,2020];
  arr_year: any;
  arr_quarter: any;
  arr_month: any;
  key: string;
  month: any;
  year: any;
  quarter: any;
  listFilterResult: couponReportModel[] = [];
  constructor(
    private modalService: NgbModal,
    private reportService: ReportService,
    private toastr: ToastrService,
    private exportService: ExcelService
    ) {
    }

  
  ngOnInit(): void {
  }


  

  fetcharraylist_coupon(model: excelModel){
    this.isLoading =  true;
    this.reportService.reportCoupon(model).subscribe(data => {
      this.arraylist_coupon = data.data;
      this.listFilterResult = data.data;
      this.listFilterResult.forEach((x) => (x.checked = false));
      this.filterResultTemplist = this.listFilterResult;    },
    err => {
        this.isLoading = false;
      })
  }

  export() {
    this.exportService.exportExcel(this.listFilterResult, 'phieuNhap');
  }

  changeStatus(event: any) {
    this.isLoading = true;
    // var thamso: excelModel;
    switch (parseInt(event)) {
      case -1:
        this.isyear = true;
        this.ismonth = true;
        this.isQuarter = true;
        this.month = null;
        this.quarter = null;
        this.year = null;
        this.key = "all";
        this.arr_month = [];
        this.arr_quarter = [];
        this.arr_year = [];
        var value = "";
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetcharraylist_coupon(thamso);
        break;
      case 0:
        this.ismonth = false;
        this.isyear = false;
        this.isQuarter = true;
        this.quarter = null;
        this.key = "bct";
        var value = "";
        // if (this.month != null || this.month != undefined) {
        //   value += this.month + "/" + this.year;
        // }
        this.arr_quarter = [];
        this.arr_month = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
        this.arr_year = [2018, 2019, 2020];
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetcharraylist_coupon(thamso);
        break;
      case 1:
        this.ismonth = true;
        this.isQuarter = false;
        this.isyear = false;
        this.month = null;
        this.key = "bcq";
        this.arr_month = [];
        this.arr_quarter = [1, 2, 3, 4];
        this.arr_year = [2018, 2019, 2020];
        var value = "";
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetcharraylist_coupon(thamso);
        break;
      case 2:
        this.isyear = false;
        this.ismonth = true;
        this.isQuarter = true;
        this.month = null;
        this.quarter = null;
        this.arr_month = [];
        this.arr_quarter = [];
        var value = "";
        this.arr_year = [2018, 2019, 2020];
        this.key = "bcn";
        value = this.year;
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetcharraylist_coupon(thamso);
        break;
      default:
        break;
    }
  }

  changeStatus2(event: any) {
    this.isLoading = true;
    // let thamso: excelModel;
    this.year = parseInt(event);
    let value = "";
    if (this.key == "bct") {
      value += this.month + "/" + this.year;
    } else if (this.key == "bcq") {
      value = this.quarter + "/" + this.year;
    } else if (this.key == "bcn") {
      value = this.year;
    }
    var thamso = {
      key: this.key,
      param: value
    };
    this.fetcharraylist_coupon(thamso);
  }

  changeStatus3(event: any) {
    this.isLoading = true;
    // let thamso: excelModel;
    this.quarter = parseInt(event);
    this.month = null;
    let value = this.quarter + "/" + this.year;
    var thamso = {
      key: this.key,
      param: value
    };
    this.fetcharraylist_coupon(thamso);
  }

  changeStatus1(event: any) {
    this.isLoading = true;
    let list = [];
    let thamso: excelModel;
    let value = "";
    this.month = parseInt(event);
    this.quarter = null;
    value += this.month + "/" + this.year;
    thamso = {
      key: this.key,
      param: value
    };
    this.fetcharraylist_coupon(thamso);
  }

}
