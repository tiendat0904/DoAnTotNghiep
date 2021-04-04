import { Pipe, PipeTransform } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';

@Pipe({
  name: 'highlight'
})
export class HighlightPipe implements PipeTransform {

  /**
   *
   */
  constructor(private sanitizer: DomSanitizer) {
  }
  transform(value: any, args: any): any {
    if (!args) {
      return value;
    }
    // Match in a case insensitive maneer
    const re = new RegExp(args, 'gi');
    const match = value.toString().match(re);
    if (!match) {
      return value;
    }
    return value.replace(re, '<mark>' + match[0] + '</mark>');
  }

}
