import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { productImageModel } from '../../models/product-image-model';

@Injectable({
  providedIn: 'root'
})
export class ProductImageService {

  constructor(private httpClient: HttpClient) { }

  create(model: productImageModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'product_images', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'product_images');
  }

  update( model: productImageModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'product_images/', model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'product_images/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'product_images/delete', modelDelete);
  }
}
