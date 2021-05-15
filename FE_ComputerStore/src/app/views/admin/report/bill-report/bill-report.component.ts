import { Component, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
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
  model: excelModel;
  modalReference: any;
  ismonth = true;
  isQuarter = true;
  isyear = true;
  closeResult: string;
  isLoading = false;
  searchedKeyword: string;
  filterResultTemplist: billReportModel[] = [];
  isSelected = true;
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
  year: any;
  quarter: any;
  listFilterResult: billReportModel[] = [];
  constructor(
    private modalService: NgbModal,
    private reportService: ReportService,
    private toastr: ToastrService,
    private exportService: ExcelService
  ) {
  }


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
    this.fetcharraylist_bill(thamso);
  }

  fetcharraylist_bill(model: excelModel) {
    this.isLoading = true;
    if(model.key == "bcq"){
      if(model.param ==="" || model.param === "NaN/"+this.year){
        this.listFilterResult = [];
      }else{
        this.reportService.reportBill(model).subscribe(data => {
      
          if(data.data !== null){
            this.arraylist_bill = data.data;
            this.listFilterResult = data.data;
            this.listFilterResult.forEach((x) => (x.checked = false));
            this.filterResultTemplist = this.listFilterResult;
          }
         
        },
          err => {
            this.isLoading = false;
          })
      }
    }else{
      this.reportService.reportBill(model).subscribe(data => {
      
        if(data.data !== null){
          this.arraylist_bill = data.data;
          this.listFilterResult = data.data;
          this.listFilterResult.forEach((x) => (x.checked = false));
          this.filterResultTemplist = this.listFilterResult;
        }
       
      },
        err => {
          this.isLoading = false;
        })
    }
    
  }

  export() {
    this.exportService.exportExcel(this.listFilterResult, 'Hoadon');
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
        this.fetcharraylist_bill(thamso);
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
        this.arr_year = [2019, 2020, 2021];
        var thamso = {
          key: this.key,
          param: value
        };
        console.log(thamso);
        this.fetcharraylist_bill(thamso);
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
        console.log(thamso);
        this.fetcharraylist_bill(thamso);
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
        this.fetcharraylist_bill(thamso);
        break;
      default:
        this.fetcharraylist_bill(thamso);
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
      value += this.quarter + "/" + this.year;
    } else if (this.key == "bcn") {
      value = this.year;
    }
    var thamso = {
      key: this.key,
      param: value
    };
    console.log(thamso);
    this.fetcharraylist_bill(thamso);
  }

  changeStatus3(event: any) {
    this.isLoading = true;
    let thamso: excelModel;
    let value = "";
    this.quarter = parseInt(event);
    this.month = null;
    value += this.quarter + "/" + this.year;
   thamso = {
      key: this.key,
      param: value
    };
    console.log(thamso);
    this.fetcharraylist_bill(thamso);
  }

  changeStatus1(event: any) {
    this.isLoading = true;
    let thamso: excelModel;
    let value = "";
    this.month = parseInt(event);
    this.quarter = null;
    value += this.month + "/" + this.year;
    thamso = {
      key: this.key,
      param: value
    };
    console.log(thamso);
    this.fetcharraylist_bill(thamso);
  }
}
