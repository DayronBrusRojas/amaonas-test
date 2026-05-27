import { CommonModule } from '@angular/common';
import { Component, Input, OnChanges } from '@angular/core';
import { SavedRequest, SessionUser } from '../request-form/request-form.component';

@Component({
  selector: 'app-my-requests',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './my-requests.component.html',
  styleUrl: './my-requests.component.css'
})
export class MyRequestsComponent implements OnChanges {
  @Input() user: SessionUser | null = null;

  requests: SavedRequest[] = [];

  ngOnChanges(): void {
    const saved = localStorage.getItem('maquetasRequests');
    const allRequests: SavedRequest[] = saved ? JSON.parse(saved) : [];
    this.requests = this.user
      ? allRequests.filter((request) => request.email === this.user?.email)
      : allRequests;
  }

  getTypeLabel(mode: SavedRequest['mode']): string {
    return mode === 'personalizar' ? 'Personalizacion' : 'Compra';
  }
}
