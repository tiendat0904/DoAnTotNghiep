import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { Routes, RouterModule } from '@angular/router';
import { MainComponent } from './main/main.component';
import { ProductDetailComponent } from './main/product-detail/product-detail.component';
import { ProductLaptopComponent } from './main/product-laptop/product-laptop.component';
import { UserComponent } from './user.component';

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
