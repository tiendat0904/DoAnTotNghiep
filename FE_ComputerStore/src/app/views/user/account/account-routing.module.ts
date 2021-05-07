import { NgModule } from '@angular/core';

import { Routes, RouterModule } from '@angular/router';
import { AccountInfoComponent } from './account-info/account-info.component';
import { ChangePasswordComponent } from './change-password/change-password.component';
import { OrderCustomerComponent } from './order-customer/order-customer.component';



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
    ]
  },
  
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AccountRoutingModule {}
