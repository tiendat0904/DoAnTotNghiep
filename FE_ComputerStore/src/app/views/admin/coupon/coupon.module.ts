import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { HTTP_INTERCEPTORS } from '@angular/common/http';




import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { CouponRoutingModule } from './coupon-routing.module';
import { PipesModule } from '../../../pipe/pipes/pipes.module';
import { CouponComponent } from './coupon.component';
import { ViewCouponComponent } from './view-coupon/view-coupon.component';
import { UpdateCouponDetailComponent } from './update-coupon-detail/update-coupon-detail.component';
import { CreateCouponComponent } from './create-coupon/create-coupon.component';
import { UpdateCouponComponent } from './update-coupon/update-coupon.component';
import { InterceptorService } from '../../../loader/interceptor.service';

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
    PipesModule,
    MatProgressSpinnerModule
  ],
  declarations: [
    CouponComponent,
    ViewCouponComponent,
    UpdateCouponDetailComponent,
    CreateCouponComponent,
    UpdateCouponComponent,
  ]
  ,
  providers:[
    {provide:HTTP_INTERCEPTORS,useClass: InterceptorService,multi:true}
  ]
})
export class CouponModule { }
