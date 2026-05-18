package com.amazonas.backend.modules.auth.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;

import com.amazonas.backend.modules.auth.dto.AuthResponse;
import com.amazonas.backend.modules.auth.dto.LoginRequest;
import com.amazonas.backend.modules.auth.dto.RegisterRequest;
import com.amazonas.backend.modules.auth.dto.CurrentUserResponse;
import com.amazonas.backend.modules.auth.enums.Role;
import com.amazonas.backend.modules.auth.service.AuthService;
import com.amazonas.backend.modules.users.model.User;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

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

    @GetMapping("/me")
    public ResponseEntity<?> me(
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        if (userDetails == null) {
            return ResponseEntity.status(401).body("Error: No se pudo extraer el usuario del token.");
        }

        if (userDetails instanceof User user) {
            CurrentUserResponse response = new CurrentUserResponse(
                    user.getId(),
                    user.getName(),
                    user.getEmail(),
                    user.getPhone(),
                    user.getRole()
            );
            return ResponseEntity.ok(response);
        }

        try {
            String email = userDetails.getUsername();
            CurrentUserResponse response = new CurrentUserResponse(
                    null, 
                    "Usuario Autenticado", 
                    email,
                    "N/A",
                    Role.CLIENT 
            );
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Error al procesar el detalle del usuario.");
        }
    }
}