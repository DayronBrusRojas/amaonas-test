import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MODELS, ModelItem } from '../../../data/model';

interface ProductWithStock {
  id: string;
  title: string;
  category: string;
  stock: number;
  imageUrl: string;
}

@Component({
  selector: 'app-gestion-stock',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './gestion-stock.component.html',
  styleUrl: './gestion-stock.component.css'
})
export class GestionStockComponent implements OnInit {
  productStock: ProductWithStock[] = [];
  searchTerm: string = '';
  editingId: string | null = null;
  tempStock: number = 0;

  ngOnInit(): void {
    const stored = localStorage.getItem('products');
    if (stored) {
      this.productStock = JSON.parse(stored);
    } else {
      const initialStock = MODELS.map((p: ModelItem) => ({
        id: p.id.toString(),
        title: p.title,
        category: p.category,
        stock: Math.floor(Math.random() * 20) + 1,
        imageUrl: p.imageUrl
      }));
      this.productStock = initialStock;
      localStorage.setItem('products', JSON.stringify(initialStock));
    }
  }

  handleEditStock(product: ProductWithStock): void {
    this.editingId = product.id;
    this.tempStock = product.stock;
  }

  handleSaveStock(productId: string): void {
    this.productStock = this.productStock.map(p =>
      p.id === productId ? { ...p, stock: this.tempStock } : p
    );
    localStorage.setItem('products', JSON.stringify(this.productStock));
    this.editingId = null;
  }

  handleCancelEdit(): void {
    this.editingId = null;
    this.tempStock = 0;
  }

  getStockStatus(stock: number) {
    if (stock === 0) {
      return { label: 'Agotado', class: 'badge-out', statusClass: 'status-out' };
    }
    if (stock < 5) {
      return { label: 'Stock Bajo', class: 'badge-low', statusClass: 'status-low' };
    }
    return { label: 'Disponible', class: 'badge-ok', statusClass: 'status-ok' };
  }

  get filteredProducts(): ProductWithStock[] {
    return this.productStock.filter(p =>
      p.title.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
      p.category.toLowerCase().includes(this.searchTerm.toLowerCase())
    );
  }

  get totalProducts(): number {
    return this.productStock.length;
  }

  get lowStockProductsCount(): number {
    return this.productStock.filter(p => p.stock > 0 && p.stock < 5).length;
  }

  get outOfStockProductsCount(): number {
    return this.productStock.filter(p => p.stock === 0).length;
  }
}
