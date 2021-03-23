import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { commentModel } from '../../models/commnent-model';

@Injectable({
  providedIn: 'root'
})
export class CommentService {

  constructor(private httpClient: HttpClient) { }

  create(model: commentModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'comments', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'comments');
  }

  update(id: any, model: commentModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'comments/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'comments',id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'comments/delete', modelDelete);
  }
}
