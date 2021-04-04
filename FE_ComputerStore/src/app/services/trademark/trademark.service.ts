import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { trademarkModel } from '../../models/trademark-model';

@Injectable({
  providedIn: 'root'
})
export class TrademarkService {

  constructor(private httpClient: HttpClient) { }

  create(model: trademarkModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'brands', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'brands');
  }

  update(id: any, model: trademarkModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'brands/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'brands/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'brands/delete', modelDelete);
  }
}
