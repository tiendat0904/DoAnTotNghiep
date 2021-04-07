import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ExportDirective} from '../export.directive';



@NgModule({
  declarations: [ExportDirective],
  imports: [
    CommonModule
  ],
  exports: [
    ExportDirective
  ]
})
export class DirectiveModule { }
