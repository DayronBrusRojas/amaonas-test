package com.amazonas.backend.modules.auth.service.impl;

import java.util.UUID;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.amazonas.backend.modules.auth.dto.AuthResponse;
import com.amazonas.backend.modules.auth.dto.LoginRequest;
import com.amazonas.backend.modules.auth.dto.RegisterRequest;
import com.amazonas.backend.modules.auth.enums.Role;
import com.amazonas.backend.modules.auth.service.AuthService;
import com.amazonas.backend.modules.users.model.User;
import com.amazonas.backend.modules.users.repository.UserRepository;
import com.amazonas.backend.security.jwt.JwtService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final JwtService jwtService;

    @Override
    public AuthResponse register(RegisterRequest request) {

        // Verificar si el email ya existe
        if (userRepository.existsByEmail(request.getEmail())) {

            throw new RuntimeException("El email ya está registrado");
        }

        // Crear usuario
        User user = new User();

        user.setId(UUID.randomUUID());

        user.setNombre(request.getNombre());

        user.setEmail(request.getEmail());

        user.setTelefono(request.getTelefono());

        user.setPassword(
                passwordEncoder.encode(request.getPassword())
        );

        user.setRole(Role.CLIENT);

        // Guardar usuario
        userRepository.save(user);

        // Generar token JWT
        String token = jwtService.generateToken(user.getEmail());

        // Retornar respuesta
        return new AuthResponse(
                token,
                user.getEmail(),
                user.getRole().name()
        );
    }

    @Override
    public AuthResponse login(LoginRequest request) {

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() ->
                        new RuntimeException("Usuario no encontrado")
                );

        // Validar contraseña
        if (!passwordEncoder.matches(
                request.getPassword(),
                user.getPassword()
        )) {

            throw new RuntimeException("Contraseña incorrecta");
        }

        // Generar token
        String token = jwtService.generateToken(user.getEmail());

        return new AuthResponse(
                token,
                user.getEmail(),
                user.getRole().name()
        );
    }
}