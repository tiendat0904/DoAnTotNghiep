import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { supplierModel } from '../../models/supplier-model';

@Injectable({
  providedIn: 'root'
})
export class SupplierService {

  constructor(private httpClient: HttpClient) { }

  create(model: supplierModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'suppliers', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'suppliers');
  }

  update(id: any, model: supplierModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'suppliers/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'suppliers/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'suppliers/delete', modelDelete);
  }
}
