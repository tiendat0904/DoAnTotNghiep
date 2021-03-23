import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class JwtService {

  constructor() { }
  getToken() {
    return localStorage.getItem('Token');
  }
}
