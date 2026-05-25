import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';
import { VendedorTab } from '../../navbar-vendedor.component';

export interface QuickAction {
  id: string;
  label: string;
  description: string;
  icon: string;
  iconColor: string;
  tab: VendedorTab | null;
}

export interface StatCard {
  id: string;
  label: string;
  value: number;
  description: string;
  icon: string;
  iconColor: string;
  descColor: string;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css',
})
export class DashboardComponent {

  @Output() tabSelected = new EventEmitter<VendedorTab>();
  @Output() goToSite = new EventEmitter<void>();

  statCards: StatCard[] = [
    {
      id: 'solicitudes',
      label: 'Solicitudes Pendientes',
      value: 0,
      description: 'Nuevas solicitudes de compra',
      icon: 'cart',
      iconColor: '#00a982',
      descColor: '#00a982',
    },
    {
      id: 'productos',
      label: 'Total Productos',
      value: 12,
      description: 'Maquetas en catálogo',
      icon: 'box',
      iconColor: '#3b82f6',
      descColor: '#3b82f6',
    },
    {
      id: 'stock',
      label: 'Stock Bajo',
      value: 0,
      description: 'Productos con menos de 5 unidades',
      icon: 'alert-circle',
      iconColor: '#f59e0b',
      descColor: '#00a982',
    },
    {
      id: 'materiales',
      label: 'Materiales Registrados',
      value: 0,
      description: 'Materiales para presupuestos',
      icon: 'package',
      iconColor: '#8b5cf6',
      descColor: '#00a982',
    },
    {
      id: 'presupuestos',
      label: 'Presupuestos Guardados',
      value: 0,
      description: 'Cotizaciones creadas',
      icon: 'calculator',
      iconColor: '#3b82f6',
      descColor: '#00a982',
    },
    {
      id: 'ventas',
      label: 'Ventas del Mes',
      value: 24,
      description: '+12% vs mes anterior',
      icon: 'trending-up',
      iconColor: '#f97316',
      descColor: '#f97316',
    },
  ];

  quickActions: QuickAction[] = [
    {
      id: 'ver-solicitudes',
      label: 'Ver Solicitudes',
      description: 'Gestionar pedidos de clientes',
      icon: 'cart',
      iconColor: '#00a982',
      tab: 'solicitudes',
    },
    {
      id: 'gestionar-stock',
      label: 'Gestionar Stock',
      description: 'Actualizar inventario',
      icon: 'box',
      iconColor: '#3b82f6',
      tab: 'gestion-stock',
    },
    {
      id: 'calcular-presupuesto',
      label: 'Calcular Presupuesto',
      description: 'Crear cotización nueva',
      icon: 'calculator',
      iconColor: '#3b82f6',
      tab: 'presupuestos',
    },
    {
      id: 'gestionar-materiales',
      label: 'Gestionar Materiales',
      description: 'Costos y stock de materiales',
      icon: 'package',
      iconColor: '#8b5cf6',
      tab: 'materiales',
    },
    {
      id: 'ver-analisis',
      label: 'Ver Análisis',
      description: 'Estadísticas de productos',
      icon: 'bar-chart',
      iconColor: '#3b82f6',
      tab: 'maquetas',
    },
    {
      id: 'ver-sitio-web',
      label: 'Ver Sitio Web',
      description: 'Vista de cliente',
      icon: 'globe',
      iconColor: '#f97316',
      tab: null,
    },
  ];

  isDemoLoaded = false;

  handleQuickAction(action: QuickAction): void {
    if (action.tab) {
      this.tabSelected.emit(action.tab);
    } else {
      this.goToSite.emit();
    }
  }

  loadDemo(): void {
    this.isDemoLoaded = true;
    this.statCards = this.statCards.map((card, i) => ({
      ...card,
      value: [3, 12, 2, 5, 4, 24][i],
    }));
  }

  clearDemo(): void {
    this.isDemoLoaded = false;
    this.statCards = this.statCards.map((card, i) => ({
      ...card,
      value: [0, 0, 0, 0, 0, 0][i],
    }));
  }
}
