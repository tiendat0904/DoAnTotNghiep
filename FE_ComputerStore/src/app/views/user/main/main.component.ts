import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-Main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  images = ['https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fkhuyenmai-laptop.png?alt=media&token=6b12593e-de8e-4e34-abe1-4cffce35f4b7',
'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fbanner-2.jpg?alt=media&token=ba82fcab-0e61-4d8c-955a-31b94c164696',
'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fbanner1.png?alt=media&token=9a4aefcf-b032-4c11-b1a8-bfc77c9863d6',
'https://firebasestorage.googleapis.com/v0/b/upload-image-904a9.appspot.com/o/computerstore%2Fbanner4.png?alt=media&token=a1b70248-924a-4c9d-8595-7043c8d7cb18'];
  constructor( private router: Router) { }

  ngOnInit(): void {
  }

  getNavigation(link, id){
    if(id === ''){
        this.router.navigate([link]);
    } else {
        this.router.navigate([link + '/' + id]);
    }
  }

}
