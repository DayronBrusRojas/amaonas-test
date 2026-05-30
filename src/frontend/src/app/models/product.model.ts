export interface Product {
  id: string;
  titulo: string;
  descripcion: string;
  descripcionDetallada: string;
  imageUrl: string;
  categoriaId: string;
  categoriaNombre: string;
  materiales: string[];
  gradoEscolar: string;
  ocasion: string[];
  materialesReciclables: boolean;
  stock: number;
  relacionados: RelatedProduct[];
}

export interface RelatedProduct {
  id: string;
  titulo: string;
  imageUrl: string;
}

export interface ProductMaterialInput {
  nombre: string;
  cantidadSugerida?: number;
  esOpcional?: boolean;
  notas?: string;
}

export interface ProductRequest {
  titulo: string;
  descripcion?: string;
  descripcionDetallada?: string;
  categoriaId: string;
  imageUrl?: string;
  materiales?: ProductMaterialInput[];
  gradoEscolar?: string;
  ocasion?: string[];
  materialesReciclables?: boolean;
  stock: number;
}

export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
  first: boolean;
  last: boolean;
  empty: boolean;
}
