import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { productPromotionDModel } from '../../models/product-promotion-model';

@Injectable({
  providedIn: 'root'
})
export class ProductPromotionService {

  
  constructor(private httpClient: HttpClient) { }

  
  create(model: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'product_promotion', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'product_promotion');
  }

  update(id: any, model: productPromotionDModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'product_promotion/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'product_promotion/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'product_promotion/delete', modelDelete);
  }
}
