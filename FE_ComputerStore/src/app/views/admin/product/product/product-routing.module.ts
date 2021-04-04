import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ProductImageComponent } from '../product-image/product-image.component';

// import { DropdownsComponent } from './dropdowns.component';
// import { BrandButtonsComponent } from './brand-buttons.component';
import { ProductComponent } from './product.component';

const routes: Routes = [
  {
    path: '',
    data: {
      title: 'Products'
    },
    children: [
      {
        path: '',
        redirectTo: 'product'
      },
      {
        path: 'product',
        component: ProductComponent,
        data: {
          title: 'Products'
        }
      },
      {
        path: 'product-image',
        component: ProductImageComponent,
        data: {
          title: 'Product-Image'
        }
      },
    //   {
    //     path: 'brand-buttons',
    //     component: BrandButtonsComponent,
    //     data: {
    //       title: 'Brand buttons'
    //     }
    //   }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProductRoutingModule {}
