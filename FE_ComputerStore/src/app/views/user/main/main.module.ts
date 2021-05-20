import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';
import { CarouselModule } from 'ngx-owl-carousel-o';


// Dropdowns Component
import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { PipesModule } from '../../../pipe/pipes/pipes.module';
import { MainComponent } from './main.component';
import { ProductDetailComponent } from './product-detail/product-detail.component';
import { ProductLaptopComponent } from './product-laptop/product-laptop.component';
// Angular

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule,
    CarouselModule
  ],
  declarations: [
    // MainComponent,
    // ProductDetailComponent
    ]
})
export class MainModule { }
