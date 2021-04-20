import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';



// Dropdowns Component

import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { UserRoutingModule } from './user-routing.module';
import { PipesModule } from '../../pipe/pipes/pipes.module';
import { UserComponent } from './user.component';
import { FooterComponent } from './footer/footer.component';
import { HeaderComponent } from './header/header.component';
import { ProductDetailComponent } from './main/product-detail/product-detail.component';
import { MainComponent } from './main/main.component';
import { CarouselModule } from 'ngx-owl-carousel-o';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { ProductLaptopComponent } from './main/product-laptop/product-laptop.component';
// Angular

@NgModule({
  imports: [
    CommonModule,
    CarouselModule,
    UserRoutingModule,
    NgbModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule
  ],
  declarations: [
    UserComponent,
    FooterComponent,
    HeaderComponent,
    MainComponent,
    ProductDetailComponent,
    ProductLaptopComponent
  ]
})
export class UserModule { }
