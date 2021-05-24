import { BrowserModule } from '@angular/platform-browser';
import { NgModule,LOCALE_ID } from '@angular/core';
import { LocationStrategy, HashLocationStrategy, PathLocationStrategy, CurrencyPipe } from '@angular/common';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { PerfectScrollbarModule } from 'ngx-perfect-scrollbar';
import { PerfectScrollbarConfigInterface } from 'ngx-perfect-scrollbar';
import {NgxPrintModule} from 'ngx-print';
import { IconModule, IconSetModule, IconSetService } from '@coreui/icons-angular';

const DEFAULT_PERFECT_SCROLLBAR_CONFIG: PerfectScrollbarConfigInterface = {
  suppressScrollX: true
};

import { AppComponent } from './app.component';

// Import containers
import { DefaultLayoutComponent } from './containers';
import { P404Component } from './views/error/404.component';
import { P500Component } from './views/error/500.component';
import { LoginComponent } from './views/login/login.component';
import { RegisterComponent } from './views/register/register.component';
import { ToastrModule } from 'ngx-toastr';
import {AngularFireModule} from "@angular/fire";
import {AngularFireStorageModule} from "@angular/fire/storage";
import {AngularFireDatabaseModule} from "@angular/fire/database";


const APP_CONTAINERS = [
  DefaultLayoutComponent
];

import {
  AppAsideModule,
  AppBreadcrumbModule,
  AppHeaderModule,
  AppFooterModule,
  AppSidebarModule,
} from '@coreui/angular';

// Import routing module
import { AppRoutingModule } from './app.routing';
import {MDBBootstrapModule} from 'angular-bootstrap-md';
// Import 3rd party components
import { CarouselModule } from 'ngx-owl-carousel-o';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { TabsModule } from 'ngx-bootstrap/tabs';
import { ChartsModule } from 'ng2-charts';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { JwtInterceptor } from './net/jwt.interceptor';
import { ProfileComponent } from './views/profile/profile/profile.component';
import { environment } from '../environments/environment';
import { SupplierComponent } from './views/admin/supplier/supplier/supplier.component';
import { UpdateSupplierComponent } from './views/admin/supplier/update-supplier/update-supplier.component';
import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { TrademarkComponent } from './views/admin/trademark/trademark/trademark.component';
import { UpdateTrademarkComponent } from './views/admin/trademark/update-trademark/update-trademark/update-trademark.component';
import { PipesModule } from './pipe/pipes/pipes.module';
import { DatePipe } from '@angular/common';
import { UpdateNewsComponent } from './views/admin/news/update-news/update-news.component';
import { NewsComponent } from './views/admin/news/news/news.component';
import { UserModule } from './views/user/user.module';
import { PromotionDateComponent } from './views/admin/promotion-date/promotion-date/promotion-date.component';
import { UpdatePromotionDateComponent } from './views/admin/promotion-date/update-promotion-date/update-promotion-date.component';
import localeFr from '@angular/common/locales/vi';
import { registerLocaleData } from '@angular/common';
import { UpdateProductPromotionComponent } from './views/admin/promotion-date/update-product-promotion/update-product-promotion.component';
import { ProductPromotionComponent } from './views/admin/promotion-date/product-promotion/product-promotion.component';
import { CustomerComponent } from './views/admin/customer/customer/customer.component';
import { UpdateCustomerComponent } from './views/admin/customer/update-customer/update-customer.component';
import { AccountModule } from './views/admin/account/account.module';
import { ForgotPasswordComponent } from './views/forgot-password/forgot-password.component';
import { ResetPasswordComponent } from './views/forgot-password/reset-password/reset-password.component';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import { NgSelectModule } from '@ng-select/ng-select';
registerLocaleData(localeFr, 'vi');
@NgModule({
  imports: [
    BrowserModule,
    NgbModule,  
    BrowserAnimationsModule,
    AppRoutingModule,
    AppAsideModule,
    AppBreadcrumbModule.forRoot(),
    AppFooterModule,
    AppHeaderModule,
    AppSidebarModule,
    ReactiveFormsModule,
    HttpClientModule,
    CarouselModule,
    FormsModule,
    AccountModule,
    UserModule,
    NgSelectModule,
    PerfectScrollbarModule,
    BsDropdownModule.forRoot(),
    TabsModule.forRoot(),
    ChartsModule,
    IconModule,
    NgxPrintModule,
    IconSetModule.forRoot(),
    ToastrModule.forRoot({
			timeOut: 2500,
			positionClass: 'toast-top-center',
			closeButton: true,
			maxOpened: 5,
			newestOnTop: true
		  }),
    AngularFireModule.initializeApp(environment.firebaseConfig),
    AngularFireStorageModule,
    AngularFireDatabaseModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule,
    MDBBootstrapModule.forRoot(),
    MatProgressSpinnerModule,
  ],
  declarations: [
    AppComponent,
    ...APP_CONTAINERS,
    P404Component,
    P500Component,
    LoginComponent,
    RegisterComponent,
    ProfileComponent,
    SupplierComponent,
    UpdateSupplierComponent,
    TrademarkComponent,
    UpdateTrademarkComponent,
    NewsComponent,
    UpdateNewsComponent,
    PromotionDateComponent,
    ProductPromotionComponent,
    UpdatePromotionDateComponent,
    UpdateProductPromotionComponent,
    CustomerComponent,
    UpdateCustomerComponent,
    ForgotPasswordComponent,
    ResetPasswordComponent
    // MainComponent,
    // ProductDetailComponent
   
  ],
  providers: [
    DatePipe,CurrencyPipe,
    {
      
      provide: LocationStrategy,
      useClass: HashLocationStrategy,
    },
    {
		  provide: HTTP_INTERCEPTORS,
		  useClass: JwtInterceptor,
		  multi: true
		},
    {
      provide: LOCALE_ID,
      useValue: 'vi' // 'de' for Germany, 'fr' for France ...
     },
    IconSetService,
  ],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
