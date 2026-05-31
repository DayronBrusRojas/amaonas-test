import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ComboboxInputComponent } from './combobox-input/combobox-input.component';

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

export interface ProductoSinSolicitud {
  id: string;
  nombre: string;
  categoria: string;
  imagenUrl: string;
}

export interface NuevaMaquetaForm {
  nombre: string;
  categoria: string;
  ocasion: string;
  gradoEscolar: string;
  descripcion: string;
  maquetaSeleccionada: string;
}

@Component({
  selector: 'app-maqueta',
  standalone: true,
  imports: [CommonModule, FormsModule, ComboboxInputComponent],
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

  ocasionesOptions: string[] = [
    'Feria Escolar', 'Exposición', 'Concurso', 'Proyecto de Clase',
    'Evento Cultural', 'Día Científico', 'Presentación Final',
  ];

  gradosOptions: string[] = [
    'Inicial / Kinder', 'Primaria', 'Secundaria',
    'Bachillerato', 'Universidad', 'Posgrado',
  ];

  categoriaColorMap: Record<string, string> = {
    'Ciencia':       '#64748b',
    'Arquitectura':  '#64748b',
    'Educativo':     '#64748b',
    'Inclusivo':     '#3b82f6',
    'Tecnología':    '#64748b',
  };

  productosSinSolicitudes: ProductoSinSolicitud[] = [
    { id: '1',  nombre: 'Sistema Digestivo',   categoria: 'Ciencia',       imagenUrl: 'https://picsum.photos/seed/digestivo/200/130'   },
    { id: '2',  nombre: 'Célula Animal',        categoria: 'Ciencia',       imagenUrl: 'https://picsum.photos/seed/celula/200/130'      },
    { id: '3',  nombre: 'Colegio Primaria',    categoria: 'Arquitectura',  imagenUrl: 'https://picsum.photos/seed/primaria/200/130'    },
    { id: '4',  nombre: 'Colegio Secundaria',  categoria: 'Arquitectura',  imagenUrl: 'https://picsum.photos/seed/secundaria/200/130'  },
    { id: '5',  nombre: 'Sistema Solar',       categoria: 'Ciencia',       imagenUrl: 'https://picsum.photos/seed/solar/200/130'       },
    { id: '6',  nombre: 'Ciclo del Agua',      categoria: 'Educativo',     imagenUrl: 'https://picsum.photos/seed/agua/200/130'        },
    { id: '7',  nombre: 'Volcán en Erupción', categoria: 'Ciencia',       imagenUrl: 'https://picsum.photos/seed/volcan/200/130'      },
    { id: '8',  nombre: 'Alfabeto Braille',    categoria: 'Inclusivo',     imagenUrl: 'https://picsum.photos/seed/braille/200/130'     },
    { id: '9',  nombre: 'Mapamundi Táctil',    categoria: 'Inclusivo',     imagenUrl: 'https://picsum.photos/seed/mapamundi/200/130'   },
    { id: '10', nombre: 'Capas de la Tierra',  categoria: 'Ciencia',       imagenUrl: 'https://picsum.photos/seed/tierra/200/130'      },
    { id: '11', nombre: 'ADN - Estructura',    categoria: 'Ciencia',       imagenUrl: 'https://picsum.photos/seed/adn/200/130'         },
    { id: '12', nombre: 'Ecosistema Acuático', categoria: 'Educativo',     imagenUrl: 'https://picsum.photos/seed/ecosistema/200/130'  },
  ];

  getCategoriaColor(cat: string): string {
    return this.categoriaColorMap[cat] ?? '#64748b';
  }

  showForm = false;
  formTab: FormTab = 'catalogo';

  imagenFile: File | null = null;
  imagenPreviewUrl: string | null = null;

  form: NuevaMaquetaForm = {
    nombre: '',
    categoria: '',
    ocasion: '',
    gradoEscolar: '',
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

  onImageSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.imagenFile = input.files[0];
      const reader = new FileReader();
      reader.onload = (e) => {
        this.imagenPreviewUrl = e.target?.result as string;
      };
      reader.readAsDataURL(input.files[0]);
    }
  }

  removeImage(): void {
    this.imagenFile = null;
    this.imagenPreviewUrl = null;
  }

  cancelar(): void {
    this.showForm = false;
    this.imagenFile = null;
    this.imagenPreviewUrl = null;
    this.form = {
      nombre: '',
      categoria: '',
      ocasion: '',
      gradoEscolar: '',
      descripcion: '',
      maquetaSeleccionada: '',
    };
  }

  guardar(): void {
    // placeholder: se conectará al backend en una siguiente etapa
    this.cancelar();
  }
}
