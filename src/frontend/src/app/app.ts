import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { Auth } from './pages/auth/auth';
import { CatalogDetailComponent } from './pages/catalog-detail/catalog-detail.component';
import { CatalogComponent } from './pages/catalog/catalog.component';
import { MODELS, ModelItem } from './pages/data/model';
import { HeaderComponent } from './pages/header/header.component';

type PageView = 'catalog' | 'detail' | 'auth';
type AuthView = 'login' | 'register';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    CommonModule,
    Auth,
    CatalogComponent,
    CatalogDetailComponent,
    HeaderComponent
  ],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class AppComponent {

  page: PageView = 'catalog';
  previousPage: PageView = 'catalog';

  selectedModel: ModelItem = MODELS[0];

  accessNotice = '';
  authView: AuthView = 'login';

  showCatalog(): void {
    this.page = 'catalog';
    this.accessNotice = '';
  }

  showDetails(model: ModelItem): void {
    this.selectedModel = model;
    this.page = 'detail';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  requestAccess(action: 'comprar' | 'personalizar'): void {
    this.previousPage = this.page === 'auth' ? this.previousPage : this.page;

    this.accessNotice = action === 'comprar'
      ? 'Para comprar una maqueta debes iniciar sesión o registrarte.'
      : 'Para personalizar tu maqueta debes iniciar sesión o registrarte.';

    this.authView = 'login';
    this.page = 'auth';
  }

  showRegister(): void {
    this.previousPage = this.page === 'auth' ? this.previousPage : this.page;

    this.accessNotice = 'Crea tu cuenta para comprar o personalizar tus maquetas.';

    this.authView = 'register';
    this.page = 'auth';
  }

  closeAuth(): void {
    this.page = this.previousPage; // 👈 vuelve al catálogo o donde estabas
    this.accessNotice = '';
  }
}