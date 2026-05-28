package com.amazonas.backend.modules.products.dto;

import java.util.List;
import java.util.UUID;

public class ProductResponse {

    private UUID id;
    private String titulo;
    private String descripcion;
    private String descripcionDetallada;
    private String imageUrl;
    private String categoriaId;
    private String categoriaNombre;
    private List<String> materiales;
    private String gradoEscolar;
    private List<String> ocasion;
    private Boolean materialesReciclables;
    private Integer stock;
    private List<RelatedProduct> relacionados;

    // Nested class for simple related product representation
    public static class RelatedProduct {
        private UUID id;
        private String titulo;
        private String imageUrl;

        public RelatedProduct() {}

        public RelatedProduct(UUID id, String titulo, String imageUrl) {
            this.id = id;
            this.titulo = titulo;
            this.imageUrl = imageUrl;
        }

        public UUID getId() {
            return id;
        }

        public void setId(UUID id) {
            this.id = id;
        }

        public String getTitulo() {
            return titulo;
        }

        public void setTitulo(String titulo) {
            this.titulo = titulo;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }
    }

    // =========================
    // GETTERS & SETTERS
    // =========================

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getDescripcionDetallada() {
        return descripcionDetallada;
    }

    public void setDescripcionDetallada(String descripcionDetallada) {
        this.descripcionDetallada = descripcionDetallada;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategoriaId() {
        return categoriaId;
    }

    public void setCategoriaId(String categoriaId) {
        this.categoriaId = categoriaId;
    }

    public String getCategoriaNombre() {
        return categoriaNombre;
    }

    public void setCategoriaNombre(String categoriaNombre) {
        this.categoriaNombre = categoriaNombre;
    }

    public List<String> getMateriales() {
        return materiales;
    }

    public void setMateriales(List<String> materiales) {
        this.materiales = materiales;
    }

    public String getGradoEscolar() {
        return gradoEscolar;
    }

    public void setGradoEscolar(String gradoEscolar) {
        this.gradoEscolar = gradoEscolar;
    }

    public List<String> getOcasion() {
        return ocasion;
    }

    public void setOcasion(List<String> ocasion) {
        this.ocasion = ocasion;
    }

    public Boolean getMaterialesReciclables() {
        return materialesReciclables;
    }

    public void setMaterialesReciclables(Boolean materialesReciclables) {
        this.materialesReciclables = materialesReciclables;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public List<RelatedProduct> getRelacionados() {
        return relacionados;
    }

    public void setRelacionados(List<RelatedProduct> relacionados) {
        this.relacionados = relacionados;
    }
}
