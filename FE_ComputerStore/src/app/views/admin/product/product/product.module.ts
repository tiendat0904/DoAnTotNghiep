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
    PipesModule
  ],
  declarations: [
    ProductComponent,
    UpdateProductComponent,
    ProductImageComponent,
    UpdateProductImageComponent,
  ]
})
export class ProductModule { }
