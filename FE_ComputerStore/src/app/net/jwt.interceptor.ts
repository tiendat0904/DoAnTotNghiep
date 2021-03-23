import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { finalize} from 'rxjs/operators';
import { JwtService } from '../services/jwt/jwt.service';
import { LoaderService } from '../loader/loader.service';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {

  constructor(private jwtService: JwtService, private loaderService: LoaderService) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    const token = this.jwtService.getToken();
    if (token) {
      request = request.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`
        }
      });
    }
    this.loaderService.show();
    return next.handle(request).pipe(
      finalize(() => {
        this.loaderService.hide();
      }),
    );
  }
}
