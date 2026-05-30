import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

import { BudgetRequest, BudgetResponse } from '../models/budget.model';

@Injectable({ providedIn: 'root' })
export class BudgetService {

  private readonly http = inject(HttpClient);
  private readonly API_URL = 'http://localhost:8080/api';

  obtenerPorSolicitud(solicitudId: string): Observable<BudgetResponse> {
    return this.http.get<BudgetResponse>(
      `${this.API_URL}/budgets/by-request/${solicitudId}`
    );
  }

  crear(request: BudgetRequest): Observable<BudgetResponse> {
    return this.http.post<BudgetResponse>(
      `${this.API_URL}/admin/budgets`, request
    );
  }

  actualizar(id: string, request: BudgetRequest): Observable<BudgetResponse> {
    return this.http.put<BudgetResponse>(
      `${this.API_URL}/admin/budgets/${id}`, request
    );
  }
}
