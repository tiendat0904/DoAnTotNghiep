import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';



// Dropdowns Component

import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { ReportRoutingModule } from './report-routing.module';
import { PipesModule } from '../../../pipe/pipes/pipes.module';
import { ReportComponent } from './report.component';
import { InventoryReportComponent } from './inventory-report/inventory-report.component';
import { DirectiveModule } from '../../../directives/directive/directive.module';
import { BillReportComponent } from './bill-report/bill-report.component';
import { CouponReportComponent } from './coupon-report/coupon-report.component';
import { EmployeeReportComponent } from './employee-report/employee-report.component';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { InterceptorService } from '../../../loader/interceptor.service';
// Angular

@NgModule({
  imports: [
    CommonModule,
    ReportRoutingModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule,
    DirectiveModule,
    MatProgressSpinnerModule
  ],
  declarations: [
      ReportComponent,
      InventoryReportComponent,
      BillReportComponent,
      CouponReportComponent,
      EmployeeReportComponent,
  ]
  ,
  providers:[
    {provide:HTTP_INTERCEPTORS,useClass: InterceptorService,multi:true}
  ]
})
export class ReportModule { }
