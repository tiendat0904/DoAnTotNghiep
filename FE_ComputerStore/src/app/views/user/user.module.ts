import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';



// Dropdowns Component

import { NgbPaginationModule } from '@ng-bootstrap/ng-bootstrap';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { UserRoutingModule } from './user-routing.module';
import { PipesModule } from '../../pipe/pipes/pipes.module';
import { UserComponent } from './user.component';

// Angular

@NgModule({
  imports: [
    CommonModule,
    UserRoutingModule,
    FormsModule,
    CommonModule,
    ReactiveFormsModule,
    NgbPaginationModule,
    Ng2SearchPipeModule,
    PipesModule
  ],
  declarations: [
    UserComponent
  ]
})
export class UserModule { }
