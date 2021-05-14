import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';

// Dropdowns Component
import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { PipesModule } from '../../../pipe/pipes/pipes.module';
import { OrderComponent } from './order.component';
import { OrderRoutingModule } from './order-routing.module';
import { ViewOrderComponent } from './view-order/view-order.component';
import { UpdateOrderDetailComponent } from './update-order-detail/update-order-detail.component';
import { CreateOrderComponent } from './create-order/create-order.component';
import { UpdateOrderComponent } from './update-order/update-order.component';
import { PrintOrderComponent } from './print-order/print-order.component';
import {NgxPrintModule} from 'ngx-print';

// Angular

@NgModule({
  imports: [
    CommonModule,
    OrderRoutingModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    NgxPrintModule,
    PipesModule
  ],
  declarations: [
    OrderComponent,
    ViewOrderComponent,
    UpdateOrderDetailComponent,
    CreateOrderComponent,
    UpdateOrderComponent,
    PrintOrderComponent,
  ]
})
export class OrderModule { }
