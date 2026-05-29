package com.amazonas.backend.modules.products.service.impl;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.amazonas.backend.modules.categories.model.Category;
import com.amazonas.backend.modules.categories.repository.CategoryRepository;
import com.amazonas.backend.modules.products.dto.ProductRequest;
import com.amazonas.backend.modules.products.dto.ProductResponse;
import com.amazonas.backend.modules.products.model.Product;
import com.amazonas.backend.modules.products.repository.ProductRepository;
import com.amazonas.backend.modules.products.service.ProductService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    @Override
    @Transactional(readOnly = true)
    public Page<ProductResponse> getProducts(String category, String search, Pageable pageable) {
        // Normalizamos parámetros vacíos
        String categoryParam = (category == null || category.trim().isEmpty()) ? null : category;
        String searchParam = (search == null || search.trim().isEmpty()) ? null : search;

        Page<Product> productPage = productRepository.searchProducts(categoryParam, searchParam, pageable);
        return productPage.map(this::mapToResponseSummary);
    }

    @Override
    @Transactional(readOnly = true)
    public ProductResponse getProductById(UUID id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

        ProductResponse response = mapToResponseDetail(product);

        // Buscar productos relacionados (de la misma categoría, limitado a 4)
        List<Product> related = productRepository.findRelatedProducts(
                product.getCategoria().getId(),
                product.getId(),
                PageRequest.of(0, 4)
        );

        List<ProductResponse.RelatedProduct> relatedResponses = related.stream()
                .map(p -> new ProductResponse.RelatedProduct(p.getId(), p.getTitulo(), p.getImageUrl()))
                .collect(Collectors.toList());

        response.setRelacionados(relatedResponses);
        return response;
    }

    @Override
    @Transactional
    public ProductResponse createProduct(ProductRequest request) {
        Category category = categoryRepository.findById(request.getCategoriaId())
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada: " + request.getCategoriaId()));

        Product product = new Product();
        updateProductFields(product, request, category);

        Product savedProduct = productRepository.save(product);
        return mapToResponseDetail(savedProduct);
    }

    @Override
    @Transactional
    public ProductResponse updateProduct(UUID id, ProductRequest request) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

        Category category = categoryRepository.findById(request.getCategoriaId())
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada: " + request.getCategoriaId()));

        updateProductFields(product, request, category);

        Product savedProduct = productRepository.save(product);
        return mapToResponseDetail(savedProduct);
    }

    @Override
    @Transactional
    public void deleteProduct(UUID id) {
        if (!productRepository.existsById(id)) {
            throw new RuntimeException("Producto no encontrado");
        }
        productRepository.deleteById(id); // Hará soft delete automáticamente gracias a @SQLDelete
    }

    // ===================================
    // PRIVATE HELPER METHODS
    // ===================================

    private void updateProductFields(Product product, ProductRequest request, Category category) {
        product.setTitulo(request.getTitulo());
        product.setDescripcion(request.getDescripcion());
        product.setDescripcionDetallada(request.getDescripcionDetallada());
        product.setCategoria(category);
        product.setImageUrl(request.getImageUrl());
        product.setMateriales(request.getMateriales());
        product.setGradoEscolar(request.getGradoEscolar());
        product.setOcasion(request.getOcasion());
        product.setMaterialesReciclables(request.getMaterialesReciclables() != null && request.getMaterialesReciclables());
        product.setStock(request.getStock());
    }

    private ProductResponse mapToResponseSummary(Product product) {
        ProductResponse response = new ProductResponse();
        response.setId(product.getId());
        response.setTitulo(product.getTitulo());
        response.setDescripcion(product.getDescripcion());
        response.setImageUrl(product.getImageUrl());
        response.setGradoEscolar(product.getGradoEscolar());
        response.setMaterialesReciclables(product.getMaterialesReciclables());
        response.setMateriales(product.getMateriales());
        response.setOcasion(product.getOcasion());
        if (product.getCategoria() != null) {
            response.setCategoriaId(product.getCategoria().getId());
            response.setCategoriaNombre(product.getCategoria().getNombre());
        }
        return response;
    }

    private ProductResponse mapToResponseDetail(Product product) {
        ProductResponse response = mapToResponseSummary(product);
        response.setDescripcionDetallada(product.getDescripcionDetallada());
        response.setStock(product.getStock());
        return response;
    }
}
