import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';



// Dropdowns Component


import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { CouponRoutingModule } from './coupon-routing.module';
import { PipesModule } from '../../../pipe/pipes/pipes.module';
import { CouponComponent } from './coupon.component';
import { ViewCouponComponent } from './view-coupon/view-coupon.component';
import { UpdateCouponDetailComponent } from './update-coupon-detail/update-coupon-detail.component';
import { CreateCouponComponent } from './create-coupon/create-coupon.component';
import { UpdateCouponComponent } from './update-coupon/update-coupon.component';

// Angular

@NgModule({
  imports: [
    CommonModule,
    CouponRoutingModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule
  ],
  declarations: [
    CouponComponent,
    ViewCouponComponent,
    UpdateCouponDetailComponent,
    CreateCouponComponent,
    UpdateCouponComponent,
  ]
})
export class CouponModule { }
