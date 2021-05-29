import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { billReportModel } from '../../../../models/bill-report-model';
import { excelModel } from '../../../../models/excel-model';
import { ExcelService } from '../../../../services/excel/excel.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-bill-report',
  templateUrl: './bill-report.component.html',
  styleUrls: ['./bill-report.component.scss']
})
export class BillReportComponent implements OnInit {

  arraylist_bill: Array<billReportModel> = [];
  filterResultTemplist: billReportModel[] = [];
  listFilterResult: billReportModel[] = [];
  model: excelModel;
  modalReference: any;
  ismonth = true;
  isQuarter = true;
  isyear = true;
  excelModel : excelModel;
  closeResult: string;
  searchedKeyword: string;
  permission: boolean;
  page = 1;
  label = -1;
  label1: any;
  label2: any;
  pageSize = 5;
  update: any;
  update1: any;
  arr_year: any;
  arr_quarter: any;
  arr_month: any;
  key: string;
  month: any;
  Revenue = 0.00;
  year: any;
  quarter: any;

  constructor(
    private modalService: NgbModal,
    private reportService: ReportService,
    private toastr: ToastrService,
    private exportService: ExcelService,
    public loaderService: LoaderService,
    private datePipe: DatePipe,
  ) { }

  ngOnInit(): void {
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
    console.log(thamso);
    this.fetchListBill(thamso);
  }

  fetchListBill(model: excelModel) {
    this.excelModel = model;
    this.Revenue = 0;
    if (model.key == "bcq") {
      if (model.param === "" || model.param === "NaN/" + this.year) {
        this.listFilterResult = [];
      } else {
        this.reportService.reportBill(model).subscribe(data => {
          if (data.data !== null) {
            this.arraylist_bill = data.data;
            this.listFilterResult = data.data;
            for (let item of this.listFilterResult) {
              this.Revenue += item.into_money;
            }
            this.listFilterResult.forEach((x) => (x.checked = false));
            this.filterResultTemplist = this.listFilterResult;
          }
        },
        err => {
          this.permission = true;
          this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
        })
      }
    } else {
      this.reportService.reportBill(model).subscribe(data => {
        if (data.data !== null) {
          this.arraylist_bill = data.data;
          this.listFilterResult = data.data;
          for (let item of this.listFilterResult) {
            this.Revenue += item.into_money;
          }
          this.listFilterResult.forEach((x) => (x.checked = false));
          this.filterResultTemplist = this.listFilterResult;
        }
      },
      err => {
        this.permission = true;
        this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho biết');
      })
    }
  }

  export() {
    this.exportService.exportExcel(this.listFilterResult, 'hoadon-'+this.excelModel.param+'-'+this.datePipe.transform(Date.now(), "dd-MM-yyyy"));
  }

  getColor(color) {
    (5)
    switch (color) {
      case "SELECTING":
        return '#5bc0de';
      case "PENDING":
        return 'rgb(255 150 0)';
      case "PROCESSING":
        return '#337ab7';
      case "PROCESSING":
        return '#337ab7';
      case "SHIPPING":
        return "rgb(99, 90, 90)";
      case "DONE":
        return '#5cb85c';
      case "CANCEL":
        return "d9534f";
    }
  }

  changeStatus(event: any) {
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
        this.fetchListBill(thamso);
        break;
      case 0:
        this.ismonth = false;
        this.isyear = false;
        this.isQuarter = true;
        this.quarter = null;
        this.key = "bct";
        var value = "";
        this.arr_quarter = [];
        this.arr_month = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
        this.arr_year = [2019, 2020, 2021];
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetchListBill(thamso);
        break;
      case 1:
        this.ismonth = true;
        this.isQuarter = false;
        this.isyear = false;
        this.month = null;
        this.key = "bcq";
        this.arr_month = [];
        this.arr_quarter = [1, 2, 3, 4];
        this.arr_year = [2019, 2020, 2021];
        var value = "";
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetchListBill(thamso);
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
        this.arr_year = [2019, 2020, 2021];
        this.key = "bcn";
        value = this.year;
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetchListBill(thamso);
        break;
      default:
        this.fetchListBill(thamso);
        break;
    }
  }

  changeStatus2(event: any) {
    this.year = parseInt(event);
    let value = "";
    if (this.key == "bct") {
      value += this.month + "/" + this.year;
    } else if (this.key == "bcq") {
      value += this.quarter + "/" + this.year;
    } else if (this.key == "bcn") {
      value = this.year;
    }
    var thamso = {
      key: this.key,
      param: value
    };
    this.fetchListBill(thamso);
  }

  changeStatus3(event: any) {
    let thamso: excelModel;
    let value = "";
    this.quarter = parseInt(event);
    this.month = null;
    value += this.quarter + "/" + this.year;
    thamso = {
      key: this.key,
      param: value
    };
    this.fetchListBill(thamso);
  }

  changeStatus1(event: any) {
    let thamso: excelModel;
    let value = "";
    this.month = parseInt(event);
    this.quarter = null;
    value += this.month + "/" + this.year;
    thamso = {
      key: this.key,
      param: value
    };
    this.fetchListBill(thamso);
  }
}
