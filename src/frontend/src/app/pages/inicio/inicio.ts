import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';
import { ViewChild } from '@angular/core';
import { ModelItem } from '../data/model';
import { BuscadorInteligente } from '../shared/components/buscador-inteligente/buscador-inteligente';

@Component({
  selector: 'app-inicio',
  standalone: true,

  imports: [
    CommonModule,
    BuscadorInteligente
  ],

  templateUrl: './inicio.html',
  styleUrls: ['./inicio.css']
})

export class Inicio {
@Output() requestAccess = new EventEmitter<'personalizar'>();
  @Output() registerClicked = new EventEmitter<void>();
@Output() modelSelected = new EventEmitter<ModelItem>();

  @Output() catalogClicked = new EventEmitter<void>();

  @ViewChild(BuscadorInteligente)
buscador!: BuscadorInteligente;

buscarTag(tag: string): void {
  this.buscador.setBusqueda(tag);
}
}
