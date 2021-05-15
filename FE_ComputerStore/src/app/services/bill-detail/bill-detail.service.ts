import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { billDetailModel } from '../../models/bill-detail-model';

@Injectable({
  providedIn: 'root'
})
export class BillDetailService {

  constructor(private httpClient: HttpClient) { }

  create(model: billDetailModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'bills_detail', model);
  }

  createNoAccount(model: billDetailModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'bills_detail_not_account', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'bills_detail');
  }

  update(id: any, model: billDetailModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'bills_detail/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'bills_detail/'+id);
  }

  getbybill(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'bills_detail_by_bill/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'bills_detail/delete', modelDelete);
  }
}
