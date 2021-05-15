import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { billDetailModel } from '../../../models/bill-detail-model';
import { BillDetailService } from '../../../services/bill-detail/bill-detail.service';

@Component({
  selector: 'app-warranty-search',
  templateUrl: './warranty-search.component.html',
  styleUrls: ['./warranty-search.component.scss']
})
export class WarrantySearchComponent implements OnInit {

  isCheck1 = true;
  isCheck = true;
  billDetailModel: billDetailModel;
  searchedWarranty: any;
  warrantyDate: any;
  orderDate :any;
  constructor(private billDetailService: BillDetailService, private datePipe: DatePipe) { }

  ngOnInit(): void {
    this.isCheck = true;
    this.isCheck1 = true;
  }

  warrantySearch() {
    if (this.searchedWarranty.length === 0) {
      this.isCheck = false;
      this.isCheck1 = false;
    } else {
      this.billDetailService.detail(this.searchedWarranty).subscribe(data => {
        if(data.data !== undefined && data.data.order_status_id === 5){
          this.billDetailModel = data.data;
        var date = new Date(data.data.updatedDate);
        this.orderDate = this.datePipe.transform(date,"dd/MM/yyyy"); 
        this.warrantyDate = this.datePipe.transform(date.setMonth(date.getMonth() + data.data.warranty), "dd/MM/yyyy");
          this.isCheck = true;
          this.isCheck1 = false;
        }else{
          this.isCheck = false;
          this.isCheck1 = true;
        }
      })
    }
  }
}
