import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ModelItem } from '../data/model';

export type RequestMode = 'personalizar' | 'comprar';

export interface SessionUser {
  name: string;
  email: string;
}

export interface SavedRequest {
  id: number;
  mode: RequestMode;
  modelTitle: string;
  fullName: string;
  email: string;
  phone: string;
  detail: string;
  explanation: boolean;
  date: string;
  selectedMaterials?: string[];
  extraMaterials?: string[];
  otherMaterials?: string;
}

@Component({
  selector: 'app-request-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './request-form.component.html',
  styleUrl: './request-form.component.css'
})
export class RequestFormComponent {
  @Input({ required: true }) model!: ModelItem;
  @Input({ required: true }) mode!: RequestMode;
  @Input() user: SessionUser | null = null;

  @Output() changedMode = new EventEmitter<RequestMode>();
  @Output() submitted = new EventEmitter<SavedRequest>();

  materialOptions = [
    'Carton reciclado',
    'Arcilla',
    'Pintura acrilica',
    'Materiales reciclables',
    'Carton',
    'Cartulina',
    'Tecnopor',
    'Duplex',
    'Fideos',
    'Plastilina',
    'Madera',
    'Algodon',
    'Aserrin',
    'Palitos de chupete',
    'Chapitas de plastico',
    'Botellas de plastico',
    'Discos',
    'Papel',
    'Temperas',
    'Pegamento',
    'Silicona'
  ];

  additionalMaterials = [
    'Carton',
    'Cartulina',
    'Tecnopor',
    'Duplex',
    'Fideos',
    'Plastilina',
    'Madera',
    'Algodon',
    'Aserrin',
    'Palitos de chupete',
    'Chapitas de plastico',
    'Botellas de plastico',
    'Discos',
    'Papel',
    'Temperas',
    'Pegamento',
    'Silicona'
  ];

  form = {
    fullName: '',
    email: '',
    phone: '',
    description: '',
    message: '',
    otherMaterials: '',
    explanation: false
  };

  selectedMaterials: string[] = [];
  selectedExtras: string[] = [];
  successMessage = '';

  ngOnChanges(): void {
    this.form.fullName = this.user?.name || this.form.fullName || 'Juan';
    this.form.email = this.user?.email || this.form.email || 'juan@gmail.com';
    this.form.phone = this.form.phone || '+51 999 999 999';
    this.selectedMaterials = this.model.materials.slice(0, 4);

    while (this.selectedMaterials.length < 4) {
      this.selectedMaterials.push(this.materialOptions[this.selectedMaterials.length]);
    }
  }

  get isCustomization(): boolean {
    return this.mode === 'personalizar';
  }

  get title(): string {
    return this.isCustomization ? 'Personalizar Maqueta' : 'Comprar Maqueta Ya Hecha';
  }

  get actionTitle(): string {
    return this.isCustomization ? 'Solicitud de Personalizacion' : 'Solicitar Compra';
  }

  get submitLabel(): string {
    return this.isCustomization ? 'Enviar Solicitud de Personalizacion' : 'Enviar Solicitud';
  }

  get alternateMode(): RequestMode {
    return this.isCustomization ? 'comprar' : 'personalizar';
  }

  toggleExtra(material: string): void {
    this.selectedExtras = this.selectedExtras.includes(material)
      ? this.selectedExtras.filter((item) => item !== material)
      : [...this.selectedExtras, material];
  }

  isExtraSelected(material: string): boolean {
    return this.selectedExtras.includes(material);
  }

  submitRequest(): void {
    const request: SavedRequest = {
      id: Date.now(),
      mode: this.mode,
      modelTitle: this.model.title,
      fullName: this.form.fullName,
      email: this.form.email,
      phone: this.form.phone,
      detail: this.isCustomization ? this.form.description : this.form.message,
      explanation: this.form.explanation,
      date: new Date().toISOString(),
      selectedMaterials: this.isCustomization ? [...this.selectedMaterials] : undefined,
      extraMaterials: this.isCustomization ? [...this.selectedExtras] : undefined,
      otherMaterials: this.isCustomization ? this.form.otherMaterials : undefined
    };

    const saved = this.getSavedRequests();
    localStorage.setItem('maquetasRequests', JSON.stringify([request, ...saved]));
    this.successMessage = 'Solicitud enviada correctamente.';
    this.submitted.emit(request);
  }

  private getSavedRequests(): SavedRequest[] {
    const saved = localStorage.getItem('maquetasRequests');
    return saved ? JSON.parse(saved) : [];
  }
}
