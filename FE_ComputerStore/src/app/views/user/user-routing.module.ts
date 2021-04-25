import { NgModule } from '@angular/core';

import { Routes, RouterModule } from '@angular/router';
import { CartComponent } from './cart/cart.component';
import { MainComponent } from './main/main.component';
import { ProductDetailComponent } from './main/product-detail/product-detail.component';
import { ProductLaptopComponent } from './main/product-laptop/product-laptop.component';
import { ProfileComponent } from './profile/profile.component';

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
        path: 'product_type/:product_type_id',
        component: ProductLaptopComponent
      },
      {
        path: 'profile',
        component: ProfileComponent,
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
