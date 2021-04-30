import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Observable, of } from 'rxjs';
import { accountModel } from '../../models/account-model';
import { AccountService } from '../../services/account/account.service';
import { JwtService } from '../../services/jwt/jwt.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  
  constructor(private jwtService: JwtService, private toastService: ToastrService, private router: Router,private accountService: AccountService) {
  }
  canActivate(): Observable<boolean> {
    const token = this.jwtService.getToken();
    let account_type_id = localStorage.getItem("account_type_id");
    if (!token || account_type_id === "3") {
      localStorage.clear();
      this.toastService.error('Hãy đăng nhập để sử dụng dịch vụ');
      this.router.navigate(['/login']);
      return of(false);
    }
    return of(true);
  }
}
