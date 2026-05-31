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
  explanationType?: string;
  explanationModel?: string;
  explanationPeople?: number;
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

  // NUEVO INPUT
  @Input() standaloneRequest = false;

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
    explanation: false,
    explanationType: 'presencial',
    explanationModel: '',
    explanationPeople: 2
  };

  explanationTypes = [
    { value: 'video', label: 'Video pregrabado', icon: '&#128249;' },
    { value: 'presencial', label: 'Explicacion presencial', icon: '&#128101;' },
    { value: 'virtual', label: 'Explicacion virtual', icon: '&#128249; &#128101;' }
  ];

  explanationModels = ['Individual', 'Grupal', 'Salon'];

  selectedMaterials: string[] = [];
  selectedExtras: string[] = [];
  successMessage = '';

  ngOnChanges(): void {

    this.form.fullName = this.user?.name || this.form.fullName || 'Juan';
    this.form.email = this.user?.email || this.form.email || 'juan@gmail.com';
    this.form.phone = this.form.phone || '+51 999 999 999';

    // Evita error si model aún no existe
    if (this.model?.materials) {
      this.selectedMaterials = this.model.materials.slice(0, 4);

      while (
        this.selectedMaterials.length < 4 &&
        this.selectedMaterials.length < this.materialOptions.length
      ) {
        this.selectedMaterials.push(
          this.materialOptions[this.selectedMaterials.length]
        );
      }
    }
  }

  get isCustomization(): boolean {
    return this.mode === 'personalizar';
  }

  get title(): string {
    return this.isCustomization
      ? 'Personalizar Maqueta'
      : 'Comprar Maqueta Ya Hecha';
  }

  get actionTitle(): string {
    return this.isCustomization
      ? 'Solicitud de Personalizacion'
      : 'Solicitar Compra';
  }

  get submitLabel(): string {
    return this.isCustomization
      ? 'Enviar Solicitud de Personalizacion'
      : 'Enviar Solicitud';
  }

  get alternateMode(): RequestMode {
    return this.isCustomization ? 'comprar' : 'personalizar';
  }

  get requiresExplanationPeople(): boolean {
    return (
      this.form.explanationModel === 'Grupal' ||
      this.form.explanationModel === 'Salon'
    );
  }

  get explanationPeopleMinimum(): number {
    return this.form.explanationModel === 'Salon' ? 10 : 2;
  }

  updateExplanationPeopleMinimum(): void {
    if (!this.requiresExplanationPeople) {
      return;
    }

    this.form.explanationPeople = this.explanationPeopleMinimum;
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
      modelTitle: this.model?.title || 'Solicitud personalizada',
      fullName: this.form.fullName,
      email: this.form.email,
      phone: this.form.phone,
      detail: this.isCustomization
        ? this.form.description
        : this.form.message,
      explanation: this.form.explanation,
      date: new Date().toISOString(),
      selectedMaterials: this.isCustomization
        ? [...this.selectedMaterials]
        : undefined,
      extraMaterials: this.isCustomization
        ? [...this.selectedExtras]
        : undefined,
      otherMaterials: this.isCustomization
        ? this.form.otherMaterials
        : undefined,
      explanationType: this.form.explanation
        ? this.form.explanationType
        : undefined,
      explanationModel: this.form.explanation
        ? this.form.explanationModel
        : undefined,
      explanationPeople:
        this.form.explanation && this.requiresExplanationPeople
          ? this.form.explanationPeople
          : undefined
    };

    const saved = this.getSavedRequests();

    localStorage.setItem(
      'maquetasRequests',
      JSON.stringify([request, ...saved])
    );

    this.successMessage = 'Solicitud enviada correctamente.';
    this.submitted.emit(request);
  }

  private getSavedRequests(): SavedRequest[] {
    const saved = localStorage.getItem('maquetasRequests');
    return saved ? JSON.parse(saved) : [];
  }
}