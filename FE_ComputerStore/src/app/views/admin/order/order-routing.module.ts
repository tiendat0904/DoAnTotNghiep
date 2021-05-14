import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CreateOrderComponent } from './create-order/create-order.component';
import { OrderComponent } from './order.component';
import { PrintOrderComponent } from './print-order/print-order.component';
import { UpdateOrderComponent } from './update-order/update-order.component';
import { ViewOrderComponent } from './view-order/view-order.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'order',
    pathMatch: 'full',
  },
  {
    path: '',
    component: OrderComponent,
    data: {
      title: 'Order'
    }
  },
  {
    path: 'print-order/:bill_id',
    component: PrintOrderComponent,
    data: {
      title: 'View Order'
    }
  },
  {
    path: 'update/:id',
    component: UpdateOrderComponent,
    data: {
      title: 'View Order'
    }
  },
  // {
  //   path: 'create',
  //   component: CreateOrderComponent,
  //   data: {
  //     title: 'View Order'
  //   }
  // },
  
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class OrderRoutingModule {}
