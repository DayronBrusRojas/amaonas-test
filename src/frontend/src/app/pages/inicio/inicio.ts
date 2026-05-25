import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';

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

  @Output() registerClicked = new EventEmitter<void>();

  @Output() catalogClicked = new EventEmitter<void>();

}
