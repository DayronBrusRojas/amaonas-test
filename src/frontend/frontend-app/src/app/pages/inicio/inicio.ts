import { Component } from '@angular/core';
import { BuscadorInteligente } from '../../shared/components/buscador-inteligente/buscador-inteligente';

@Component({
  selector: 'app-inicio',
  imports: [BuscadorInteligente],
  templateUrl: './inicio.html',
  styleUrl: './inicio.css',
})
export class Inicio {}
