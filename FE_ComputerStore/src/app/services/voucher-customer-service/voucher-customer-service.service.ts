import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { voucherCustomerModel } from '../../models/voucher-customer-model';

@Injectable({
  providedIn: 'root'
})
export class VoucherCustomerServiceService {

  constructor(private httpClient: HttpClient) { }

  create(model: voucherCustomerModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'voucher-customer', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'voucher-customer');
  }

  update(id: any, model: voucherCustomerModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'voucher-customer/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'voucher-customer/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'voucher-customer/delete', modelDelete);
  }
}
