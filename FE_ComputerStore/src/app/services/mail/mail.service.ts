import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { mailModel } from '../../models/mail-model';

@Injectable({
  providedIn: 'root'
})
export class MailService {

  constructor(private httpClient: HttpClient) { }

  senEmail(model: mailModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'sendemail', model);
  }
}
