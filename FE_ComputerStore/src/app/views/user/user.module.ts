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
import { CartComponent } from './cart/cart.component';
import { ProfileComponent } from './profile/profile.component';
import { OrderSucessComponent } from './order-sucess/order-sucess.component';
import { SearchComponent } from './search/search.component';
import { NewsComponent } from './news/news.component';
import { AccountModule } from './account/account.module';
import { WarrantySearchComponent } from './warranty-search/warranty-search.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';

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
    AccountModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule,
    MDBBootstrapModule.forRoot(),
  ],
  declarations: [
    UserComponent,
    FooterComponent,
    HeaderComponent,
    MainComponent,
    ProductDetailComponent,
    ProductLaptopComponent,
    CartComponent,
    ProfileComponent,
    OrderSucessComponent,
    SearchComponent,
    NewsComponent,
    WarrantySearchComponent,

  ]
})
export class UserModule { }
