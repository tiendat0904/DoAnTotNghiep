import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CouponComponent } from './coupon.component';
import { CreateCouponComponent } from './create-coupon/create-coupon.component';
import { UpdateCouponComponent } from './update-coupon/update-coupon.component';
import { ViewCouponComponent } from './view-coupon/view-coupon.component';


export const routes: Routes = [
  {
    path: '',
    redirectTo: 'coupon',
    pathMatch: 'full',
  },
  {
    path: '',
    component: CouponComponent,
    data: {
      title: 'Coupon'
    }
  },
  {
    path: 'view/:id',
    component: ViewCouponComponent,
    data: {
      title: 'View Coupon'
    }
  },
  {
    path: 'create',
    component: CreateCouponComponent,
    data: {
      title: 'View Coupon'
    }
  },
  {
    path: 'update/:id',
    component: UpdateCouponComponent,
    data: {
      title: 'Update Coupon'
    }
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class CouponRoutingModule { }
