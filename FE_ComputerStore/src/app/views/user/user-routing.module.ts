import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { Routes, RouterModule } from '@angular/router';
import { ProductDetailComponent } from './main/product-detail/product-detail.component';
import { UserComponent } from './user.component';

// import { DropdownsComponent } from './dropdowns.component';
// import { BrandButtonsComponent } from './brand-buttons.component';

const routes: Routes = [
  {
    path: '',
    data: {
      title: 'User'
    },
    component:UserComponent,
  },
  
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class UserRoutingModule {}
