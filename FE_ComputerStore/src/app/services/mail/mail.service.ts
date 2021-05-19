import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { forgotPasswordModel } from '../../models/forgot-password-model';
import { mailModel } from '../../models/mail-model';

@Injectable({
  providedIn: 'root'
})
export class MailService {

  constructor(private httpClient: HttpClient) { }

  sendEmail(model: mailModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'sendemail', model);
  }

  sendcode(model: forgotPasswordModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'sendcode', model);
  }

  
}
