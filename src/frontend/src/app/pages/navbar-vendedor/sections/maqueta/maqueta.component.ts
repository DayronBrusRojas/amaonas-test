import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

export type FormTab = 'catalogo' | 'nueva';

export interface MaquetaStat {
  id: string;
  label: string;
  value: number;
  valueColor: string;
  iconColor: string;
}

export interface AnalisisStat {
  id: string;
  label: string;
  value: string | number;
  valueColor: string;
  subtext?: string;
  icon: string;
  iconColor: string;
}

export interface NuevaMaquetaForm {
  nombre: string;
  categoria: string;
  urlImagen: string;
  descripcion: string;
  maquetaSeleccionada: string;
}

@Component({
  selector: 'app-maqueta',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './maqueta.component.html',
  styleUrl: './maqueta.component.css',
})
export class MaquetaComponent {

  stats: MaquetaStat[] = [
    {
      id: 'configuradas',
      label: 'Maquetas Configuradas',
      value: 0,
      valueColor: '#1a2a3a',
      iconColor: '#3b82f6',
    },
    {
      id: 'disponibles',
      label: 'Maquetas Disponibles',
      value: 12,
      valueColor: '#8b5cf6',
      iconColor: '#8b5cf6',
    },
    {
      id: 'sin-configurar',
      label: 'Sin Configurar',
      value: 12,
      valueColor: '#f97316',
      iconColor: '#f97316',
    },
  ];

  analisisStats: AnalisisStat[] = [
    {
      id: 'total-solicitudes',
      label: 'Total Solicitudes',
      value: 0,
      valueColor: '#1a2a3a',
      icon: 'bar-chart',
      iconColor: '#3b82f6',
    },
    {
      id: 'productos-solicitados',
      label: 'Productos Solicitados',
      value: 0,
      valueColor: '#1a2a3a',
      icon: 'trending-up',
      iconColor: '#22c55e',
    },
    {
      id: 'categoria-popular',
      label: 'Categoría Popular',
      value: 'N/A',
      valueColor: '#8b5cf6',
      subtext: '0 solicitudes',
      icon: 'star',
      iconColor: '#8b5cf6',
    },
    {
      id: 'sin-solicitudes',
      label: 'Sin Solicitudes',
      value: 12,
      valueColor: '#f97316',
      icon: 'alert-circle',
      iconColor: '#f97316',
    },
  ];

  categorias: string[] = ['Educativa', 'Arquitectura', 'Ciencia', 'Tecnología'];

  showForm = false;
  formTab: FormTab = 'catalogo';

  form: NuevaMaquetaForm = {
    nombre: '',
    categoria: 'Educativa',
    urlImagen: '',
    descripcion: '',
    maquetaSeleccionada: '',
  };

  get configuradas(): number {
    return this.stats.find(s => s.id === 'configuradas')?.value ?? 0;
  }

  abrirForm(): void {
    this.showForm = true;
    this.formTab = 'catalogo';
  }

  cancelar(): void {
    this.showForm = false;
    this.form = {
      nombre: '',
      categoria: 'Educativa',
      urlImagen: '',
      descripcion: '',
      maquetaSeleccionada: '',
    };
  }

  guardar(): void {
    // placeholder: se conectará al backend en una siguiente etapa
    this.cancelar();
  }
}
