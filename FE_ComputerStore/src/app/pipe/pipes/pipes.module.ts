import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HighlightPipe } from '../highlight.pipe';



@NgModule({
  declarations: [HighlightPipe],
  exports: [HighlightPipe],
  imports: [
    CommonModule
  ]
})
export class PipesModule { }
