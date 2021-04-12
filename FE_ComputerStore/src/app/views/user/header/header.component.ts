import { Component, OnInit } from '@angular/core';
declare var $: any;
@Component({
  selector: 'app-header1',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
    $(document).ready(function(){
      $('#header-basket').hover(
        function(){
          $('#header-hide').show();
        },
        function(){
          $('#header-hide').hide();
        }
      )
      $('#header-hide').hover(
        function(){
          $('#header-hide').show();
        },
        function(){
          $(this).hide();
        }
      )
    })
    
  }

}
