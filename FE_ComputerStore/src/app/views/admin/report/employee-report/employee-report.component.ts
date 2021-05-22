import { Component, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { employeeReportModel } from '../../../../models/employee-report-model';
import { excelModel } from '../../../../models/excel-model';
import { ExcelService } from '../../../../services/excel/excel.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-employee-report',
  templateUrl: './employee-report.component.html',
  styleUrls: ['./employee-report.component.scss']
})
export class EmployeeReportComponent implements OnInit {

  arraylist_employee: Array<employeeReportModel> = [];
  listFilterResult: employeeReportModel[] = [];
  filterResultTemplist: employeeReportModel[] = [];
  model: excelModel;
  modalReference: any;
  ismonth = true;
  isQuarter = true;
  isyear = true;
  closeResult: string;
  searchedKeyword: string;
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
  update2: [2018, 2019, 2020, 2021];

  constructor(
    private reportService: ReportService,
    private exportService: ExcelService,
    public loaderService: LoaderService
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
    this.fetchListBillByEmployee(thamso);
  }

  fetchListBillByEmployee(model: excelModel) {
    if (model.key == "bcq") {
      if (model.param === "" || model.param === "NaN/" + this.year) {
        this.listFilterResult = [];
      } else {
        this.reportService.reportEmployee(model).subscribe(data => {
          if (data.data !== null) {
            this.arraylist_employee = data.data;
            this.listFilterResult = data.data;
            this.listFilterResult.forEach((x) => (x.checked = false));
            this.filterResultTemplist = this.listFilterResult;
          }
        })
      }
    } else {
      this.reportService.reportEmployee(model).subscribe(data => {
        if (data.data !== null) {
          this.arraylist_employee = data.data;
          this.listFilterResult = data.data;
          this.listFilterResult.forEach((x) => (x.checked = false));
          this.filterResultTemplist = this.listFilterResult;
        }
      })
    }
  }

  export() {
    this.exportService.exportExcel(this.listFilterResult, 'Nhanvien');
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
        this.fetchListBillByEmployee(thamso);
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
        this.arr_year = [2018, 2019, 2020, 2021];
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetchListBillByEmployee(thamso);
        break;
      case 1:
        this.ismonth = true;
        this.isQuarter = false;
        this.isyear = false;
        this.month = null;
        this.key = "bcq";
        this.arr_month = [];
        this.arr_quarter = [1, 2, 3, 4];
        this.arr_year = [2018, 2019, 2020, 2021];
        var value = "";
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetchListBillByEmployee(thamso);
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
        this.arr_year = [2018, 2019, 2020, 2021];
        this.key = "bcn";
        value = this.year;
        var thamso = {
          key: this.key,
          param: value
        };
        this.fetchListBillByEmployee(thamso);
        break;
      default:
        break;
    }
  }

  changeStatus2(event: any) {
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
    this.fetchListBillByEmployee(thamso);
  }

  changeStatus3(event: any) {
    this.quarter = parseInt(event);
    this.month = null;
    let value = this.quarter + "/" + this.year;
    var thamso = {
      key: this.key,
      param: value
    };
    this.fetchListBillByEmployee(thamso);
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
    this.fetchListBillByEmployee(thamso);
  }

}
