import { Component, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
import { LoaderService } from '../../../../loader/loader.service';
import { iventoryReportModel } from '../../../../models/inventory-report-model';
import { ExcelService } from '../../../../services/excel/excel.service';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-inventory-report',
  templateUrl: './inventory-report.component.html',
  styleUrls: ['./inventory-report.component.scss']
})
export class InventoryReportComponent implements OnInit {

  arraylist_product_inventory: Array<iventoryReportModel> = [];
  listFilterResult: iventoryReportModel[] = [];
  filterResultTemplist: iventoryReportModel[] = [];
  modalReference: any;
  isDelete = true;
  closeResult: string;
  searchedKeyword: string;
  permission : boolean;
  isSelected = true;
  page = 1;
  pageSize = 5;
  totalAmount = 0;

  constructor(
    private reportService: ReportService,
    private toastr: ToastrService,
    private exportService: ExcelService,
    public loaderService: LoaderService
  ) {
  }

  ngOnInit(): void {
    this.fetchListProductInventory();
  }

  fetchListProductInventory() {
    this.reportService.reportIventoryProduct().subscribe(data => {
      this.arraylist_product_inventory = data.data;
      this.listFilterResult = data.data;
      for (let item of this.listFilterResult) {
        this.totalAmount += item.amount;
      }
    },
    err => {
      this.permission = true;
      this.toastr.error(err.error.error);
    })
  }

  export() {
    this.exportService.exportExcel(this.listFilterResult, 'HangTonKho');
  }

}
