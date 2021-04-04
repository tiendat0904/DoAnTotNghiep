import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { orderTypeModel } from '../../models/order-type-model';

@Injectable({
  providedIn: 'root'
})
export class OrderTypeService {

  constructor(private httpClient: HttpClient) { }

  create(model: orderTypeModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'order-type', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'order-type');
  }

  update(id: any, model: orderTypeModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'order-type/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'order-type/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'order-type/delete', modelDelete);
  }
}
