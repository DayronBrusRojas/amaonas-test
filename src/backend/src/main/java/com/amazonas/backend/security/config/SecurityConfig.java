package com.amazonas.backend.security.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.amazonas.backend.security.jwt.JwtFilter;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor // Inyecta automáticamente el JwtFilter final por constructor
public class SecurityConfig {

    // Inyectamos el filtro personalizado que lee y valida los tokens JWT
    private final JwtFilter jwtFilter;

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
            // 1. Deshabilitamos CSRF porque los tokens JWT ya protegen contra este ataque por diseño
            .csrf(csrf -> csrf.disable())

            // LÍNEA MUY IMPORTANTE: Cambiamos a arquitectura sin estado (STATELESS).
            // Le dice a Spring Boot que NO guarde sesiones HTTP en el servidor. Cada petición
            // debe ser independiente y traer su propio token de Angular para ser reconocida.
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

            // 2. Reglas de autorización para las peticiones entrantes
            .authorizeHttpRequests(auth -> auth

                // Las rutas de login y registro son públicas (libres de token)
                .requestMatchers(
                    "/api/auth/**"
                ).permitAll()

                // Cualquier otra URL del backend requiere que el usuario esté autenticado
                .anyRequest().authenticated()
            )

            // LA LÍNEA MÁS IMPORTANTE DEL FILTRO:
            // Ponemos nuestro JwtFilter ANTES del filtro de login tradicional de Spring (UsernamePasswordAuthenticationFilter).
            // De este modo, si llega un token válido de Angular, el filtro intercepta la petición,
            // loguea al usuario en milisegundos y le da paso libre antes de que salte el login básico.
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        // Encriptador oficial para las contraseñas con el algoritmo robusto BCrypt
        return new BCryptPasswordEncoder();
    }

    @Bean
    // BLOQUE IMPORTANTE NUEVO: El AuthenticationManager es el motor central de autenticación de Spring.
    // Lo necesitamos exponer como Bean para poder usarlo en tu "AuthService"
    // cuando hagamos el endpoint de POST /auth/login para validar credenciales reales.
    AuthenticationManager authenticationManager(
            AuthenticationConfiguration config
    ) throws Exception {

        return config.getAuthenticationManager();
    }
}