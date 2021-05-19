import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';



// Dropdowns Component

import { ProductComponent } from './product.component';
import { ProductRoutingModule } from './product-routing.module';
import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { PipesModule } from '../../../../pipe/pipes/pipes.module';
import { UpdateProductComponent } from '../update-product/update-product.component';
import { ProductImageComponent } from '../product-image/product-image.component';
import { UpdateProductImageComponent } from '../update-product-image/update-product-image.component';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { InterceptorService } from '../../../../loader/interceptor.service';
// Angular

@NgModule({
  imports: [
    CommonModule,
    ProductRoutingModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule,
    MatProgressSpinnerModule
  ],
  declarations: [
    ProductComponent,
    UpdateProductComponent,
    ProductImageComponent,
    UpdateProductImageComponent,
  ]
  ,
  providers:[
    {provide:HTTP_INTERCEPTORS,useClass: InterceptorService,multi:true}
  ]
})
export class ProductModule { }
