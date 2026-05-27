import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BuscadorInteligente } from './buscador-inteligente';

describe('BuscadorInteligente', () => {
  let component: BuscadorInteligente;
  let fixture: ComponentFixture<BuscadorInteligente>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [BuscadorInteligente],
    }).compileComponents();

    fixture = TestBed.createComponent(BuscadorInteligente);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
