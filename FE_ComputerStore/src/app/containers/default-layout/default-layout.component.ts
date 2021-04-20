import {Component, OnInit} from '@angular/core';
import { Router } from '@angular/router';
import { avatarDefault } from '../../../environments/environment';
import { AccountService } from '../../services/account/account.service';
import { navItems } from '../../_nav';

@Component({
  selector: 'app-dashboard',
  templateUrl: './default-layout.component.html',
  styleUrls: ['./default-layout.component.scss']
})
export class DefaultLayoutComponent implements OnInit{
  public sidebarMinimized = false;
  public navItems = navItems;
  name: any;
  picture: any;
  urlPictureDefault = avatarDefault;

  toggleMinimize(e) {
    this.sidebarMinimized = e;
  }

  constructor(private router: Router,
    private accountService:AccountService) {}
  
  ngOnInit(): void {
    this.picture = this.urlPictureDefault;
    this.fetchgetInfo();
  }

  fetchgetInfo(){
    this.accountService.getInfo().subscribe(data => {
      this.name = "Hi "+data.data.full_name;
      if(data.image == null){
        this.picture = this.urlPictureDefault;
      }else{
        this.picture = data.data.image;
      }
    },)
  }

  onLogout() {
    localStorage.removeItem('Token');
    localStorage.clear();
    this.picture = this.urlPictureDefault;
    this.router.navigate(['/']);
  }

  onProfile(){
    this.router.navigate(['/admin/profile']);
  }
}
