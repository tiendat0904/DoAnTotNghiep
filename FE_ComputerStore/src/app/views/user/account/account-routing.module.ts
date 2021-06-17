import { NgModule } from '@angular/core';

import { Routes, RouterModule } from '@angular/router';
import { AccountInfoComponent } from './account-info/account-info.component';
import { ChangePasswordComponent } from './change-password/change-password.component';
import { OrderCustomerComponent } from './order-customer/order-customer.component';
import { OrderDetailCustomerComponent } from './order-detail-customer/order-detail-customer.component';
import { VoucherCustomerComponent } from './voucher-customer/voucher-customer.component';



const routes: Routes = [
  {
    path: '',
    children: [
      {
        path: 'account-info',
        component: AccountInfoComponent
      },
      {
        path: 'change-password',
        component: ChangePasswordComponent
      },
      {
        path: 'order',
        component: OrderCustomerComponent
      },
      {
        path: 'voucher-customer',
        component: VoucherCustomerComponent
      },
      {
        path: 'order/:bill_id',
        component: OrderDetailCustomerComponent
      },
    ]
  },
  
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AccountRoutingModule {}
