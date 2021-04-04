import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { newsModel } from '../../models/news-model';


@Injectable({
  providedIn: 'root'
})
export class NewsService {

  constructor(private httpClient: HttpClient) { }

  create(model: newsModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'news', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'news');
  }

  update(id: any, model: newsModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'news/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'news/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'news/delete', modelDelete);
  }
}
