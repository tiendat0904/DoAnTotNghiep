import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';



// Dropdowns Component

import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { CarouselModule } from 'ngx-owl-carousel-o';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { AccountComponent } from './account.component';
import { AccountInfoComponent } from './account-info/account-info.component';
import { AccountRoutingModule } from './account-routing.module';
import { ChangePasswordComponent } from './change-password/change-password.component';
import { OrderCustomerComponent } from './order-customer/order-customer.component';
import { OrderDetailCustomerComponent } from './order-detail-customer/order-detail-customer.component';
import { VoucherCustomerComponent } from './voucher-customer/voucher-customer.component';

// Angular

@NgModule({
  imports: [
    CommonModule,
    CarouselModule,
    NgbModule,
    FormsModule,
    AccountRoutingModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
  ],
  declarations: [
    AccountComponent,
    AccountInfoComponent,
    ChangePasswordComponent,
    OrderCustomerComponent,
    OrderDetailCustomerComponent,
    VoucherCustomerComponent
  ]
})
export class AccountModule { }
