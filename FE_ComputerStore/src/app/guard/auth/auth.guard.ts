import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { Observable, of } from 'rxjs';
import { JwtService } from '../../services/jwt/jwt.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(private jwtService: JwtService, private toastService: ToastrService, private router: Router) {
  }
  canActivate(): Observable<boolean> {
    const token = this.jwtService.getToken();
    if (!token) {

      this.router.navigate(['/login']);
      this.toastService.error('Hãy đăng nhập để sử dụng dịch vụ');
      return of(false);
    }
    return of(true);
  }
}
