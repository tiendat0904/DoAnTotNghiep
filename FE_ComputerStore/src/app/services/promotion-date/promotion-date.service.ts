import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { promotionDateModel } from '../../models/promotion-date-model';

@Injectable({
  providedIn: 'root'
})
export class PromotionDateService {

  constructor(private httpClient: HttpClient) { }

  create(model: promotionDateModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'promotion_date', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'promotion_date');
  }

  update(id: any, model: promotionDateModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'promotion_date/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'promotion_date/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'promotion_date/delete', modelDelete);
  }
}
