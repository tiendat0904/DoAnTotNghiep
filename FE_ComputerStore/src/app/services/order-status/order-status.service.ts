import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { orderStatusModel } from '../../models/order-status-model';

@Injectable({
  providedIn: 'root'
})
export class OrderStatusService {

  constructor(private httpClient: HttpClient) { }

  create(model: orderStatusModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'order_status', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'order_status');
  }

  update(id: any, model: orderStatusModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'order_status/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'order_status/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'order_status/delete', modelDelete);
  }
}
