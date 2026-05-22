import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';

type PageView = 'catalog' | 'detail' | 'auth';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {

  @Input() activePage: PageView = 'catalog';

  @Output() catalogClicked = new EventEmitter<void>();
  @Output() loginClicked = new EventEmitter<void>();
  @Output() registerClicked = new EventEmitter<void>();

  menuOpen = false;

  toggleMenu(): void {
    this.menuOpen = !this.menuOpen;
  }

  closeMenu(): void {
    this.menuOpen = false;
  }
}