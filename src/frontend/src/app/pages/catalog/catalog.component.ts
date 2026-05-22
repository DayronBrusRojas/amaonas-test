import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CATEGORIES, Category, MODELS, ModelItem } from '../data/model';

@Component({
  selector: 'app-catalog',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './catalog.component.html',
  styleUrl: './catalog.component.css'
})
export class CatalogComponent {
  @Output() viewDetails = new EventEmitter<ModelItem>();

  searchTerm = '';
  selectedCategory: Category = 'Todos';
  categories = CATEGORIES;
  models = MODELS;

  get filteredModels(): ModelItem[] {
    const term = this.normalize(this.searchTerm);

    return this.models.filter((model) => {
      const matchesCategory = this.selectedCategory === 'Todos' || model.category === this.selectedCategory;
      const searchableText = this.normalize(`${model.title} ${model.category} ${model.level} ${model.description}`);
      return matchesCategory && searchableText.includes(term);
    });
  }

  selectCategory(category: Category): void {
    this.selectedCategory = category;
  }

  showDetails(model: ModelItem): void {
    this.viewDetails.emit(model);
  }

  private normalize(value: string): string {
    return value
      .toLowerCase()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '');
  }
}
