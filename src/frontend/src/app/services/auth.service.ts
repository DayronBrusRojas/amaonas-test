import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import {
  LoginRequest,
  LoginVendorRequest,
  RegisterRequest,
  AuthResponse,
  CurrentUserResponse
} from '../models/auth.model';

@Injectable({ providedIn: 'root' })
export class AuthService {

  private readonly http = inject(HttpClient);
  private readonly API_URL = 'http://localhost:8080/api/auth';

  register(request: RegisterRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/register`, request);
  }

  registerVendor(request: RegisterRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/vendor/register`, request);
  }

  login(request: LoginRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/login`, request);
  }

  vendorLogin(request: LoginVendorRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/vendor/login`, request);
  }

  getVendorProfile(token: string): Observable<CurrentUserResponse> {
    return this.http.get<CurrentUserResponse>(`${this.API_URL}/vendor/me`, {
      headers: { Authorization: token }
    });
  }
}
