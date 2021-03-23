import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { accountTypeModel } from '../../models/account-type-model';

@Injectable({
  providedIn: 'root'
})
export class AccountTypeService {

  constructor(private httpClient: HttpClient) { }

  create(model: accountTypeModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'account_type', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'account_type');
  }

  update(id: any, model: accountTypeModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'account_type/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'account_type',id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'accounts/delete', modelDelete);
  }
}
