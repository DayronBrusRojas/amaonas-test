package com.amazonas.backend.modules.auth.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import com.amazonas.backend.modules.auth.dto.AuthResponse;
import com.amazonas.backend.modules.auth.dto.CurrentUserResponse;
import com.amazonas.backend.modules.auth.dto.LoginRequest;
import com.amazonas.backend.modules.auth.dto.LoginVendorRequest;
import com.amazonas.backend.modules.auth.dto.RegisterRequest;
import com.amazonas.backend.modules.auth.service.AuthService;
import com.amazonas.backend.modules.users.model.User;
import com.amazonas.backend.modules.vendors.model.Vendor;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    // =========================
    // CLIENT AUTH
    // =========================

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(
            @Valid @RequestBody RegisterRequest request
    ) {

        return ResponseEntity.ok(
                authService.register(request)
        );
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(
            @Valid @RequestBody LoginRequest request
    ) {

        return ResponseEntity.ok(
                authService.login(request)
        );
    }

    // =========================
    // VENDOR AUTH
    // =========================

    @PostMapping("/vendor/login")
    public ResponseEntity<AuthResponse> vendorLogin(
            @Valid @RequestBody LoginVendorRequest request
    ) {

        return ResponseEntity.ok(
                authService.vendorLogin(request)
        );
    }

    // =========================
    // CURRENT USER
    // =========================

    @GetMapping("/me")
    public ResponseEntity<?> me(
            @AuthenticationPrincipal UserDetails userDetails
    ) {

        if (userDetails == null) {

            return ResponseEntity.status(401)
                    .body("Error: usuario no autenticado");
        }

        // =========================
        // USER
        // =========================

        if (userDetails instanceof User user) {

            CurrentUserResponse response = new CurrentUserResponse(
                    user.getId(),
                    user.getNombre(),
                    user.getEmail(),
                    user.getTelefono(),
                    user.getRole()
            );

            return ResponseEntity.ok(response);
        }

        // =========================
        // VENDOR
        // =========================

        if (userDetails instanceof Vendor vendor) {

            CurrentUserResponse response = new CurrentUserResponse(
                    vendor.getId(),
                    vendor.getNombre(),
                    vendor.getEmail(),
                    null,
                    vendor.getRole()
            );

            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(401)
                .body("Error al procesar usuario autenticado");
    }
}