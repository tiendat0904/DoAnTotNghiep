import { NgModule } from '@angular/core';

import { Routes, RouterModule } from '@angular/router';
import { AccountComponent } from './account/account.component';
import { BuildPcComponent } from './build-pc/build-pc.component';
import { CartComponent } from './cart/cart.component';
import { MainComponent } from './main/main.component';
import { ProductDetailComponent } from './main/product-detail/product-detail.component';
import { ProductLaptopComponent } from './main/product-laptop/product-laptop.component';
import { NewsComponent } from './news/news.component';
import { OrderSucessComponent } from './order-sucess/order-sucess.component';
import { ProductByBrandComponent } from './product-by-brand/product-by-brand.component';
import { ProfileComponent } from './profile/profile.component';
import { SearchComponent } from './search/search.component';
import { WarrantySearchComponent } from './warranty-search/warranty-search.component';

// import { DropdownsComponent } from './dropdowns.component';
// import { BrandButtonsComponent } from './brand-buttons.component';

const routes: Routes = [
  {
    path: '',
    data: {
      title: 'User'
    },
    children: [
      {
        path: '',
        component: MainComponent
      },
      {
        path: 'product-type/:product_type_id',
        component: ProductLaptopComponent
      },
      {
        path: 'brand/:trademark_id',
        component: ProductByBrandComponent
      },
      {
        path: 'build-pc',
        component: BuildPcComponent
      },
      {
        path: 'warranty-search',
        component: WarrantySearchComponent,
      },
      {
        path: 'account',
        component: AccountComponent,
        children: [
          {
            path: '',
            loadChildren: () => import('./account/account.module').then(m => m.AccountModule)
          },
        ]
      }, 
      {
        path: 'send-cart',
        component: OrderSucessComponent,
      },
      {
        path: 'news',
        component: NewsComponent,
      },
      {
        path: 'profile',
        component: ProfileComponent,
      },
      {
        path:'search',
        component: SearchComponent
      },
      {
        path: 'cart',
        component: CartComponent,
      },
      {
        path:':product_id',
        component: ProductDetailComponent
      },
      
    ]
  },
  
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class UserRoutingModule {}
