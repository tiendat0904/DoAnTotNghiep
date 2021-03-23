import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ProductTypeService {

  constructor(private httpClient: HttpClient) { }

  create(model: ProductTypeService): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'product_type', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'product_type');
  }

  update(id: any, model: ProductTypeService): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'product_type/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'product_type',id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'product_type/delete', modelDelete);
  }
}
