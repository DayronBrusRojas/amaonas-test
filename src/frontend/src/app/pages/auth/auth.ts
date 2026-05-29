import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges } from '@angular/core';
import { FormsModule } from '@angular/forms';

type AuthView = 'login' | 'register';

interface UserAccount {
  name: string;
  email: string;
  password: string;
}

@Component({
  selector: 'app-auth',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './auth.html',
  styleUrl: './auth.css'
})
export class Auth implements OnChanges {

  @Input() accessNotice = '';
  @Input() initialView: AuthView = 'login';

  @Output() closed = new EventEmitter<void>();
  @Output() authenticated = new EventEmitter<UserAccount>();

  view: AuthView = 'login';
  recoverySent = false;
  successMessage = '';
  errorMessage = '';

  login: UserAccount = {
    name: '',
    email: '',
    password: ''
  };

  register = {
    name: '',
    email: '',
    password: '',
    confirmPassword: ''
  };

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['initialView']) {
      this.view = this.initialView;
      this.clearMessages();
    }
  }

  get isLogin(): boolean {
    return this.view === 'login';
  }

  switchToLogin(): void {
    this.view = 'login';
    this.clearMessages();
  }

  switchToRegister(): void {
    this.view = 'register';
    this.clearMessages();
  }

  closeModal(): void {
    this.clearMessages();

    this.login = { name: '', email: '', password: '' };
    this.register = { name: '', email: '', password: '', confirmPassword: '' };

    this.closed.emit();
  }

  submitLogin(): void {
    this.clearMessages();

    const account = this.findAccount(this.login.email);

    if (!account || account.password !== this.login.password) {
      this.errorMessage = 'Correo o contraseña incorrectos.';
      return;
    }

    this.successMessage = `Bienvenido, ${account.name}. Ya puedes continuar con tu maqueta.`;
    this.authenticated.emit(account);
  }

  submitRegister(): void {
    this.clearMessages();

    if (this.register.password.length < 6) {
      this.errorMessage = 'La contraseña debe tener mínimo 6 caracteres.';
      return;
    }

    if (this.register.password !== this.register.confirmPassword) {
      this.errorMessage = 'Las contraseñas no coinciden.';
      return;
    }

    const accounts = this.getAccounts();
    const email = this.register.email.trim().toLowerCase();

    if (accounts.some(a => a.email === email)) {
      this.errorMessage = 'Este correo ya está registrado.';
      return;
    }

    accounts.push({
      name: this.register.name.trim(),
      email,
      password: this.register.password
    });

    localStorage.setItem('maquetasAccounts', JSON.stringify(accounts));

    this.login.email = email;
    this.login.password = '';
    this.view = 'login';

    this.successMessage = 'Cuenta creada. Ahora inicia sesión.';
  }

  sendRecovery(): void {
    this.clearMessages();

    if (!this.login.email.trim()) {
      this.errorMessage = 'Escribe tu correo electrónico para recuperar tu cuenta.';
      return;
    }

    this.recoverySent = true;
    this.successMessage = 'Se envió un enlace de recuperación (simulado).';
  }

  private clearMessages(): void {
    this.recoverySent = false;
    this.successMessage = '';
    this.errorMessage = '';
  }

  private findAccount(email: string): UserAccount | undefined {
    return this.getAccounts().find(
      a => a.email === email.trim().toLowerCase()
    );
  }

  private getAccounts(): UserAccount[] {
    const saved = localStorage.getItem('maquetasAccounts');
    return saved ? JSON.parse(saved) : [];
  }
}
