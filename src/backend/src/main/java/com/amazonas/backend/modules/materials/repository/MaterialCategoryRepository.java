package com.amazonas.backend.modules.materials.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.amazonas.backend.modules.materials.model.MaterialCategory;
import java.util.Optional;

@Repository
public interface MaterialCategoryRepository extends JpaRepository<MaterialCategory, String> {
    Optional<MaterialCategory> findByNombreIgnoreCase(String nombre);
}
