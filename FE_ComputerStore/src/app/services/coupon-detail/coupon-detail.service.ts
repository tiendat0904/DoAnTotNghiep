import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { couponDetailModel } from '../../models/coupon-detail-model';


@Injectable({
  providedIn: 'root'
})
export class CouponDetailService {

  constructor(private httpClient: HttpClient) { }

  create(model: couponDetailModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'coupons_detail', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'coupons_detail');
  }

  update(id: any, model: couponDetailModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'coupons_detail/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'coupons_detail',id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'coupons_detail/delete', modelDelete);
  }
}
