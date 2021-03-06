import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { NgSelectModule } from '@ng-select/ng-select';
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
import { ProductTypeComponent } from '../product-type/product-type.component';
import { UpdateProductTypeComponent } from '../update-product-type/update-product-type.component';
// Angular

@NgModule({
  imports: [
    ProductRoutingModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule,
    MatProgressSpinnerModule,
    NgSelectModule
  ],
  declarations: [
    ProductComponent,
    UpdateProductComponent,
    ProductImageComponent,
    UpdateProductImageComponent,
    ProductTypeComponent,
    UpdateProductTypeComponent,
  ]
  ,
  providers:[
    {provide:HTTP_INTERCEPTORS,useClass: InterceptorService,multi:true}
  ]
})
export class ProductModule { }
