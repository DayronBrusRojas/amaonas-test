import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
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

  limpiarBusqueda(): void {
    this.searchTerm = '';
    this.resultados = [];
  }

  setBusqueda(texto: string): void {
    this.searchTerm = texto;
    this.buscar();
  }

}