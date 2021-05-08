import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { voucherModel } from '../../models/voucher-model';

@Injectable({
  providedIn: 'root'
})
export class VoucherService {

  constructor(private httpClient: HttpClient) { }

  create(model: voucherModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'voucher', model);
  }

  getAll(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'voucher');
  }

  update(id: any, model: voucherModel): Observable<any>{
    return this.httpClient.put(environment.BASE_API_URL + environment.BASE_API +'voucher/' + id, model);
  }

  detail(id: any): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL + environment.BASE_API +'voucher/'+id);
  }

  delete(modelDelete: any): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'voucher/delete', modelDelete);
  }
}
