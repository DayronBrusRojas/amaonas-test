import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';
import { tap } from 'rxjs/operators';

import { API_BASE_URL } from '../config/api.config';
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
  private readonly API_URL = `${API_BASE_URL}/auth`;

  private readonly currentUserSubject = new BehaviorSubject<CurrentUserResponse | null>(null);
  readonly currentUser$ = this.currentUserSubject.asObservable();

  constructor() {
    this.loadSession();
  }

  register(request: RegisterRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/register`, request);
  }

  registerVendor(request: RegisterRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/vendor/register`, request);
  }

  login(request: LoginRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/login`, request).pipe(
      tap(response => this.saveSession(response))
    );
  }

  vendorLogin(request: LoginVendorRequest): Observable<AuthResponse> {
    return this.http.post<AuthResponse>(`${this.API_URL}/vendor/login`, request).pipe(
      tap(response => this.saveSession(response))
    );
  }

  getVendorProfile(): Observable<CurrentUserResponse> {
    return this.http.get<CurrentUserResponse>(`${this.API_URL}/vendor/me`).pipe(
      tap(user => this.currentUserSubject.next(user))
    );
  }

  saveSession(auth: AuthResponse): void {
    localStorage.setItem('auth_token', auth.token);
    localStorage.setItem('auth_email', auth.email);
    localStorage.setItem('auth_role', auth.role);
    
    this.currentUserSubject.next({
      id: '', // Se llenará al llamar a getVendorProfile() o similar
      nombre: '',
      email: auth.email,
      role: auth.role
    });
  }

  loadSession(): void {
    const token = this.getToken();
    const email = localStorage.getItem('auth_email');
    const role = localStorage.getItem('auth_role');

    if (token && email && role) {
      this.currentUserSubject.next({
        id: '',
        nombre: '',
        email,
        role
      });
    }
  }

  getToken(): string | null {
    return localStorage.getItem('auth_token');
  }

  logout(): void {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('auth_email');
    localStorage.removeItem('auth_role');
    this.currentUserSubject.next(null);
  }

  isLoggedIn(): boolean {
    return this.getToken() !== null;
  }

  getUserRole(): string | null {
    return localStorage.getItem('auth_role');
  }
}
