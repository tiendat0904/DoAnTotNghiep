import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { avatarDefault } from '../../../../environments/environment';
import { AccountService } from '../../../services/account/account.service';
declare var $: any;
@Component({
  selector: 'app-header1',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent implements OnInit {

  url:any;
  name: any;
  picture: any;
  urlPictureDefault = avatarDefault;
  constructor(
    private accountService:AccountService) {}

  ngOnInit(): void {
    $('#header-hide').hide();
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

    this.picture = this.urlPictureDefault;
    this.name = "Đăng nhập";
    this.url = "/#/login";
    this.fetchgetInfo();
    console.log(localStorage);
    if(localStorage.length !== 0){
      this.url = "/#/profile";
    }else{
      this.url = "#/login";
      this.name = "Đăng nhập";
    }
    if(this.name !== null){
     
    }
    if(this.name ){
      
    }
    
  }

  fetchgetInfo(){
    this.accountService.getInfo().subscribe(data => {
      this.name = data.data.full_name;
      if(data.image == null){
        this.picture = this.urlPictureDefault;
      }else{
        this.picture = data.data.image;
      }
    },error =>{
      this.url = "#/login";
      this.name = "Đăng nhập";
    })
  }

  

}
