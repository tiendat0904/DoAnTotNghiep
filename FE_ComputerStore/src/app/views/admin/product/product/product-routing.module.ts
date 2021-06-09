import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ProductImageComponent } from '../product-image/product-image.component';
import { ProductTypeComponent } from '../product-type/product-type.component';
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
        path: 'product-type',
        component: ProductTypeComponent,
        data: {
          title: 'Product-Type'
        }
      },
      {
        path: 'product-image',
        component: ProductImageComponent,
        data: {
          title: 'Product-Image'
        }
      },
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ProductRoutingModule { }
