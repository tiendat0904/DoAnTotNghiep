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
    DirectiveModule
  ],
  declarations: [
      ReportComponent,
      InventoryReportComponent,
      BillReportComponent,
      CouponReportComponent,
      EmployeeReportComponent,
  ]
})
export class ReportModule { }
