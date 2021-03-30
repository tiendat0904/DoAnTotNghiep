import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { LocationStrategy, HashLocationStrategy, PathLocationStrategy } from '@angular/common';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { PerfectScrollbarModule } from 'ngx-perfect-scrollbar';
import { PERFECT_SCROLLBAR_CONFIG } from 'ngx-perfect-scrollbar';
import { PerfectScrollbarConfigInterface } from 'ngx-perfect-scrollbar';

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

// Import 3rd party components
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { TabsModule } from 'ngx-bootstrap/tabs';
import { ChartsModule } from 'ng2-charts';
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
import { UpdateProductComponent } from './views/admin/product/update-product/update-product.component';
import { ProductComponent } from './views/admin/product/product/product.component';

@NgModule({
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    AppAsideModule,
    AppBreadcrumbModule.forRoot(),
    AppFooterModule,
    AppHeaderModule,
    AppSidebarModule,
    ReactiveFormsModule,
    HttpClientModule,
    FormsModule,
    PerfectScrollbarModule,
    BsDropdownModule.forRoot(),
    TabsModule.forRoot(),
    ChartsModule,
    IconModule,
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
    ProductComponent,
    UpdateProductComponent
  ],
  providers: [
    {
      provide: LocationStrategy,
      useClass: HashLocationStrategy,
    },
    {
		  provide: HTTP_INTERCEPTORS,
		  useClass: JwtInterceptor,
		  multi: true
		},
    IconSetService,
  ],
  bootstrap: [ AppComponent ]
})
export class AppModule { }
