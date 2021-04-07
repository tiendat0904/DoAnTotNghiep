import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { billReportModel } from '../models/bill-report-model';
import { couponReportModel } from '../models/coupon-report-model';
import { employeeReportModel } from '../models/employee-report-model';
import { excelModel } from '../models/excel-model';

@Injectable({
  providedIn: 'root'
})
export class ReportService {

  constructor(private httpClient: HttpClient) { }

  reportCoupon(model: excelModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'reports/report-coupons', model);
  }

  reportBill(model: excelModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'reports/report-bills', model);
  }

  reportEmployee(model: excelModel): Observable<any>{
    return this.httpClient.post(environment.BASE_API_URL + environment.BASE_API +'reports/report-employees', model);
  }

  reportIventoryProduct(): Observable<any>{
    return this.httpClient.get(environment.BASE_API_URL+ environment.BASE_API+'reports/inventory-product');
  }
}
