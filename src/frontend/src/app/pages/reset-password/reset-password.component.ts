import { CommonModule } from '@angular/common';
import { Component, EventEmitter, OnInit, Output, inject } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, ReactiveFormsModule, ValidationErrors, Validators } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-reset-password',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './reset-password.component.html',
  styleUrl: './reset-password.component.css'
})
export class ResetPasswordComponent implements OnInit {

  private readonly fb = inject(FormBuilder);
  private readonly route = inject(ActivatedRoute);
  private readonly authService = inject(AuthService);

  @Output() success = new EventEmitter<void>();

  resetForm: FormGroup;
  token = '';
  isValidToken = false;
  isCheckingToken = true;
  isLoading = false;
  successMessage = '';
  errorMessage = '';

  constructor() {
    this.resetForm = this.fb.group({
      password: ['', [Validators.required, Validators.minLength(6)]],
      confirmPassword: ['', [Validators.required]]
    }, { validators: this.passwordMatchValidator });
  }

  ngOnInit(): void {
    // Obtener el token de los Query Params
    this.route.queryParams.subscribe(params => {
      this.token = params['token'] || '';
      
      if (!this.token) {
        // Fallback por si no carga por ActivatedRoute, leer directamente de window.location
        const urlParams = new URLSearchParams(window.location.search);
        this.token = urlParams.get('token') || '';
      }

      if (!this.token) {
        this.isCheckingToken = false;
        this.isValidToken = false;
        this.errorMessage = 'El token de recuperación no es válido o está ausente.';
        return;
      }

      this.verifyToken();
    });
  }

  verifyToken(): void {
    this.authService.validateResetToken(this.token).subscribe({
      next: (isValid) => {
        this.isCheckingToken = false;
        this.isValidToken = isValid;
        if (!isValid) {
          this.errorMessage = 'El enlace de recuperación ha expirado (límite de 15 minutos) o no existe.';
        }
      },
      error: () => {
        this.isCheckingToken = false;
        this.isValidToken = false;
        this.errorMessage = 'Error al validar el token de recuperación.';
      }
    });
  }

  passwordMatchValidator(control: AbstractControl): ValidationErrors | null {
    const password = control.get('password');
    const confirmPassword = control.get('confirmPassword');

    if (!password || !confirmPassword) {
      return null;
    }

    return password.value === confirmPassword.value ? null : { passwordMismatch: true };
  }

  get passwordStrength(): { label: string, color: string, width: string } {
    const pwd = this.resetForm.get('password')?.value || '';
    if (!pwd) return { label: 'Ninguna', color: '#cbd5e1', width: '0%' };
    if (pwd.length < 6) return { label: 'Muy corta', color: '#ef4444', width: '20%' };

    let score = 0;
    if (pwd.length >= 8) score++;
    if (/[A-Z]/.test(pwd)) score++;
    if (/[0-9]/.test(pwd)) score++;
    if (/[^A-Za-z0-9]/.test(pwd)) score++;

    if (score <= 1) return { label: 'Débil', color: '#f97316', width: '40%' };
    if (score === 2) return { label: 'Media', color: '#eab308', width: '70%' };
    return { label: 'Fuerte', color: '#22c55e', width: '100%' };
  }

  submitReset(): void {
    if (this.resetForm.invalid) {
      this.resetForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.successMessage = '';
    this.errorMessage = '';

    const newPassword = this.resetForm.get('password')?.value;

    this.authService.resetPassword(this.token, newPassword).subscribe({
      next: () => {
        this.isLoading = false;
        this.successMessage = 'Tu contraseña ha sido restablecida exitosamente con encriptación segura.';
        this.resetForm.reset();
        setTimeout(() => {
          this.success.emit();
        }, 3000);
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = err?.error?.message || err?.error || 'No se pudo restablecer la contraseña. Inténtalo de nuevo.';
      }
    });
  }

  goBack(): void {
    this.success.emit();
  }
}
