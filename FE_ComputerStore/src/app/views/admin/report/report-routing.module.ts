import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { BillReportComponent } from './bill-report/bill-report.component';
import { InventoryReportComponent } from './inventory-report/inventory-report.component';
import { ReportComponent } from './report.component';


const routes: Routes = [
  {
    path: '',
    data: {
        title: 'Report'
      },
    children: [
    {
      path: 'inventory-report',
      component: InventoryReportComponent,
    },
    {
        path: 'bill-report',
        component: BillReportComponent,
    },
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ReportRoutingModule {}
