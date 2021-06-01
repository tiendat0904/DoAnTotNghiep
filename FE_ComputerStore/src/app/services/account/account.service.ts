import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { accountModel } from '../../models/account-model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AccountService {

  constructor(private httpClient: HttpClient) { }

  create(model: accountModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'accounts', model);
  }

  login(model: accountModel): Observable<any> {
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API + "login", model);
  }

  loginbysocal(model: accountModel): Observable<any> {
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API + "loginbysocal", model);
  }

  register(userModel: accountModel): Observable<any> {
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API + "register", userModel);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'accounts');
  }

  getAccountByCustomer(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'getaccountbycustomer');
  }

  getAccountCustomer(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'getaccountcustomer');
  }

  getAccountOfEmployee(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'getaccountofemployee');
  }

  getAccountEmployeeByAdmin(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'getaccountemployeebyadmin');
  }
  
  getInfo(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'info');
  }

  update(model: accountModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'accounts', model);
  }

  resetPassword(model: accountModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'reset-password', model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'accounts/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'accounts/delete', modelDelete);
  }
}
