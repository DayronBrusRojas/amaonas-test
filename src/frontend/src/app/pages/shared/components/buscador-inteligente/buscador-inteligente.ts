import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MODELS, ModelItem } from '../../../data/model';

@Component({
  selector: 'app-buscador-inteligente',
  standalone: true,

  imports: [
    CommonModule,
    FormsModule
  ],

  templateUrl: './buscador-inteligente.html',
  styleUrls: ['./buscador-inteligente.css'],
})

export class BuscadorInteligente {

  @Output() requestAccess = new EventEmitter<'personalizar'>();
  @Output() modelSelected = new EventEmitter<ModelItem>();

  searchTerm = '';
  resultados: ModelItem[] = [];

  buscar(): void {

    const texto = this.searchTerm.toLowerCase().trim();

    if (!texto) {
      this.resultados = [];
      return;
    }

    this.resultados = MODELS.filter(model => {

      return (
        model.title.toLowerCase().includes(texto) ||
        model.category.toLowerCase().includes(texto) ||
        model.description.toLowerCase().includes(texto) ||
        model.materials.some(material =>
          material.toLowerCase().includes(texto)
        )
      );

    });

  }

  abrirDetalle(item: ModelItem): void {
    this.modelSelected.emit(item);
  }

  limpiarBusqueda(): void {
    this.searchTerm = '';
    this.resultados = [];
  }

  setBusqueda(texto: string): void {
    this.searchTerm = texto;
    this.buscar();
  }

}