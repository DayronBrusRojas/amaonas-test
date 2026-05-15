package com.amazonas.backend.modules.vendors.model;

import java.time.LocalDateTime;
import java.util.UUID;

import com.amazonas.backend.common.entity.BaseEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "vendors")
public class Vendor extends BaseEntity {

    @Id
    private UUID id;

    @Column(nullable = false, length = 255)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(nullable = false)
    private String phone;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "can_manage_materials")
    private Boolean canManageMaterials = false;

    @Column(name = "can_create_budgets")
    private Boolean canCreateBudgets = false;

    @Column(name = "can_view_all_requests")
    private Boolean canViewAllRequests = false;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public Boolean getCanManageMaterials() {
        return canManageMaterials;
    }

    public void setCanManageMaterials(Boolean canManageMaterials) {
        this.canManageMaterials = canManageMaterials;
    }

    public Boolean getCanCreateBudgets() {
        return canCreateBudgets;
    }

    public void setCanCreateBudgets(Boolean canCreateBudgets) {
        this.canCreateBudgets = canCreateBudgets;
    }

    public Boolean getCanViewAllRequests() {
        return canViewAllRequests;
    }

    public void setCanViewAllRequests(Boolean canViewAllRequests) {
        this.canViewAllRequests = canViewAllRequests;
    }

    public LocalDateTime getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
    }
}