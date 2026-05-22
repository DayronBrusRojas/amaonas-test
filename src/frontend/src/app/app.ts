import { Component } from '@angular/core';
import { Auth } from './pages/auth/auth';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [Auth],
  template: '<app-auth></app-auth>',
})
export class App {}