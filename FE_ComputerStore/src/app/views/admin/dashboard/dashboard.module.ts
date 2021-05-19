import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ChartsModule } from 'ng2-charts';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { ButtonsModule } from 'ngx-bootstrap/buttons';

import { DashboardComponent } from './dashboard.component';
import { DashboardRoutingModule } from './dashboard-routing.module';
import { CommonModule } from '@angular/common';
import { PipesModule } from '../../../pipe/pipes/pipes.module';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { InterceptorService } from '../../../loader/interceptor.service';
@NgModule({
  imports: [
    FormsModule,
    PipesModule,
    CommonModule,
    DashboardRoutingModule,
    ChartsModule,
    BsDropdownModule,
    MatProgressSpinnerModule,
    
    
    ButtonsModule.forRoot()
  ],
  providers:[
    {provide:HTTP_INTERCEPTORS,useClass: InterceptorService,multi:true}
  ],
  declarations: [ DashboardComponent ]
})
export class DashboardModule { }
