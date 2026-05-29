package com.amazonas.backend.modules.categories.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.amazonas.backend.modules.categories.model.Category;

@Repository
public interface CategoryRepository extends JpaRepository<Category, String> {
}
