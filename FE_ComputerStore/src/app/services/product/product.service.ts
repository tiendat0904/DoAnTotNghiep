import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { productModel } from '../../models/product-model';

@Injectable({
  providedIn: 'root'
})
export class ProductService {

  constructor(private httpClient: HttpClient) { }

  create(model: productModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'products', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'products');
  }

  update(id: any, model: productModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'products/' + id, model);
  }

  updateview(id: any, model: productModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'productupdateview/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'products/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'products/delete', modelDelete);
  }
}
