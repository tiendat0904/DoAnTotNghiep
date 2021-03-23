import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { couponModel } from '../../models/coupon-model';


@Injectable({
  providedIn: 'root'
})
export class CouponService {

  constructor(private httpClient: HttpClient) { }

  create(model: couponModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'coupons', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'coupons');
  }

  update(id: any, model: couponModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'coupons/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'coupons',id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'coupons/delete', modelDelete);
  }
}
