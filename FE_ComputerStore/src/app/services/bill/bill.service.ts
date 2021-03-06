import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { billModel } from '../../models/bill-model';

@Injectable({
  providedIn: 'root'
})
export class BillService {

  constructor(private httpClient: HttpClient) { }

  create(model: billModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'bills', model);
  }

  createNotAccount(model: billModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'bills_not_account', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'bills');
  }

  getBill(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'getBill');
  }

  update(id: any, model: billModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'bills/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'bills/'+id);
  }

  getByAccount(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'billsbyaccount/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'bills/delete', modelDelete);
  }
}
