import { Component, OnInit } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ToastrService } from 'ngx-toastr';
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
  modalReference: any;
  isDelete = true;
  closeResult: string;
  isLoading = false;
  searchedKeyword: string;
  filterResultTemplist: iventoryReportModel[] = [];
  isSelected = true;
  page = 1;
  pageSize = 5;
  listFilterResult: iventoryReportModel[] = [];
  constructor(
    private modalService: NgbModal,
    private reportService: ReportService,
    private toastr: ToastrService,
    private exportService: ExcelService
    ) {
    }

  
  ngOnInit(): void {
    this.fetcharraylist_product_inventory();
  }


  

  fetcharraylist_product_inventory(){
    this.isLoading =  true;
    this.reportService.reportIventoryProduct().subscribe(data => {
      this.arraylist_product_inventory = data.data;
      this.listFilterResult = data.data;
   },
    err => {
        this.isLoading = false;
      })
  }

  export() {
    this.exportService.exportExcel(this.listFilterResult, 'HangTonKho');
  }

}
