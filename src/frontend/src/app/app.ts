import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { Auth } from './pages/auth/auth';
import { CatalogDetailComponent } from './pages/catalog-detail/catalog-detail.component';
import { CatalogComponent } from './pages/catalog/catalog.component';
import { MODELS, ModelItem } from './pages/data/model';
import { HeaderComponent } from './pages/header/header.component';
import { FooterComponent } from './pages/footer/footer.component';
import { NavbarVendedorComponent } from './pages/navbar-vendedor/navbar-vendedor.component';
import { Inicio } from './pages/inicio/inicio';
import { Nosotros } from './pages/nosotros/nosotros';
import { MyRequestsComponent } from './pages/my-requests/my-requests.component';
import { RequestFormComponent, RequestMode, SavedRequest, SessionUser } from './pages/request-form/request-form.component';
import { BuscadorInteligente } from './pages/shared/components/buscador-inteligente/buscador-inteligente';

type PageView = 'inicio' | 'nosotros' |'catalog' | 'detail' | 'auth' | 'request' | 'requests'|'vendedor';
type AuthView = 'login' | 'register';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    CommonModule,
    Auth,
    CatalogComponent,
    CatalogDetailComponent,
    FooterComponent,
    HeaderComponent,
    NavbarVendedorComponent,
    Inicio,
    Nosotros,
    MyRequestsComponent,
    RequestFormComponent,
    BuscadorInteligente
  ],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class AppComponent {
  
  page: PageView = 'vendedor';
  previousPage: PageView = 'inicio';

  selectedModel: ModelItem = MODELS[0];

  accessNotice = '';
  authView: AuthView = 'login';
   currentUser: SessionUser | null = this.getSavedUser();
   requestMode: RequestMode = 'personalizar';
  isStandaloneRequest = false;

  showCatalog(): void {
    this.page = 'catalog';
    this.accessNotice = '';
  }

  showInicio(): void {
  this.page = 'inicio';
  this.accessNotice = '';
}

showNosotros(): void {
  this.page = 'nosotros';
  this.accessNotice = '';
}

showDetails(model: ModelItem): void {

  this.isStandaloneRequest = false;

  this.selectedModel = model;
  this.page = 'detail';

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });

}



requestAccess(action: RequestMode): void {

  this.isStandaloneRequest = false;

  if (this.currentUser) {
    this.openRequest(action);
    return;
  }

  this.previousPage = this.page === 'auth'
    ? this.previousPage
    : this.page;

  this.accessNotice = action === 'comprar'
    ? 'Para comprar una maqueta debes iniciar sesion o registrarte.'
    : 'Para personalizar tu maqueta debes iniciar sesion o registrarte.';

  this.authView = 'login';
  this.page = 'auth';
}
openStandaloneRequest(): void {

  this.isStandaloneRequest = true;

  if (!this.currentUser) {

    this.previousPage = this.page;

    this.accessNotice =
      'Para personalizar tu maqueta debes iniciar sesion o registrarte.';

    this.authView = 'login';
    this.page = 'auth';

    return;
  }

  this.requestMode = 'personalizar';

  this.page = 'request';

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  });
}

  showLogin(): void {
    this.previousPage = 'catalog';
    this.accessNotice = '';
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
    this.page = this.previousPage;
    this.accessNotice = '';
  }

    completeLogin(user: SessionUser): void {
    this.currentUser = {
      name: user.name,
      email: user.email
    };

    localStorage.setItem('maquetasCurrentUser', JSON.stringify(this.currentUser));
    this.accessNotice = '';
    this.showCatalog();
  }
  openRequest(mode: RequestMode): void {
    this.requestMode = mode;
    this.page = 'request';
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  switchRequestMode(mode: RequestMode): void {
    this.requestMode = mode;
  }

  showRequests(): void {
    if (!this.currentUser) {
      this.showLogin();
      return;
    }

    this.page = 'requests';
    this.accessNotice = '';
  }

  handleRequestSubmitted(_request: SavedRequest): void {
    this.page = 'requests';
  }

  logout(): void {
    this.currentUser = null;
    localStorage.removeItem('maquetasCurrentUser');
    this.showCatalog();
  }

  private getSavedUser(): SessionUser | null {
    const saved = localStorage.getItem('maquetasCurrentUser');
    return saved ? JSON.parse(saved) : null;
  }
  
  showVendedor(): void {
    this.page = 'vendedor';
  }

  salirPanel(): void {
    this.page = 'catalog';
  }
}
