import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Import Containers
import { DefaultLayoutComponent } from './containers';
import { AuthGuard } from './guard/auth/auth.guard';
import { NewsComponent } from './views/admin/news/news/news.component';
import { ProductPromotionComponent } from './views/admin/promotion-date/product-promotion/product-promotion.component';
import { PromotionDateComponent } from './views/admin/promotion-date/promotion-date/promotion-date.component';
import { SupplierComponent } from './views/admin/supplier/supplier/supplier.component';
import { TrademarkComponent } from './views/admin/trademark/trademark/trademark.component';

import { P404Component } from './views/error/404.component';
import { P500Component } from './views/error/500.component';
import { LoginComponent } from './views/login/login.component';
import { ProfileComponent } from './views/profile/profile/profile.component';
import { RegisterComponent } from './views/register/register.component';
import { MainComponent } from './views/user/main/main.component';
import { ProductDetailComponent } from './views/user/main/product-detail/product-detail.component';
import { UserComponent } from './views/user/user.component';

export const routes: Routes = [
  {
    path: 'login',
    component: LoginComponent,
    data: {
      title: 'Login Page'
    },
  },
  {
    path: 'register',
    component: RegisterComponent,
    data: {
      title: 'Register Page'
    }
  },
  {
    
    path: '',
    component: UserComponent,
    children: [
      {
        path: '',
        loadChildren: () => import('./views/user/user.module').then(m => m.UserModule)
      },
      // {
      //   path: '',
      //   component: MainComponent
      // },
      // {
      //   path:':product_id',
      //   component: ProductDetailComponent
      // },
    ]
  },
  {
    path: '404',
    component: P404Component,
    data: {
      title: 'Page 404'
    }
  },
  {
    path: '500',
    component: P500Component,
    data: {
      title: 'Page 500'
    }
  },
  
 
  {
    path: 'admin',
    component: DefaultLayoutComponent,
    data: {
      title: 'Home'
    },
    canActivate : [AuthGuard],
    children: [
      {
        path: 'base',
        loadChildren: () => import('./views/base/base.module').then(m => m.BaseModule)
      },
      {
        path: 'buttons',
        loadChildren: () => import('./views/buttons/buttons.module').then(m => m.ButtonsModule)
      },
      {
        path: 'charts',
        loadChildren: () => import('./views/chartjs/chartjs.module').then(m => m.ChartJSModule)
      },
      {
        path: 'dashboard',
        loadChildren: () => import('./views/admin/dashboard/dashboard.module').then(m => m.DashboardModule)
      },
      {
        path: 'icons',
        loadChildren: () => import('./views/icons/icons.module').then(m => m.IconsModule)
      },
      {
        path: 'notifications',
        loadChildren: () => import('./views/notifications/notifications.module').then(m => m.NotificationsModule)
      },
      {
        path: 'theme',
        loadChildren: () => import('./views/theme/theme.module').then(m => m.ThemeModule)
      },
      {
        path: 'widgets',
        loadChildren: () => import('./views/widgets/widgets.module').then(m => m.WidgetsModule)
      },
      {
        path: 'profile',
        component: ProfileComponent,
      },
      {
        path: 'supplier',
        component: SupplierComponent,
      },
      {
        path: 'trademark',
        component: TrademarkComponent,
      },
      {
        path: 'promotion-date',
        component: PromotionDateComponent,
      },
      {
        path: 'product-promotion',
        component: ProductPromotionComponent,
      },
      {
        path: 'product',
        loadChildren: () => import('./views/admin/product/product/product.module').then(m => m.ProductModule)
      },
      {
        path: 'coupon',
        loadChildren: () => import('./views/admin/coupon/coupon.module').then(m => m.CouponModule)
      },
      {
        path: 'order',
        loadChildren: () => import('./views/admin/order/order.module').then(m => m.OrderModule)
      },
      {
        path: 'news',
        component: NewsComponent,
      },
      {
        path: 'report',
        loadChildren: () => import('./views/admin/report/report.module').then(m => m.ReportModule)
      },
    ]
  },
  { path: '**', component: P404Component }
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { relativeLinkResolution: 'legacy' }) ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
