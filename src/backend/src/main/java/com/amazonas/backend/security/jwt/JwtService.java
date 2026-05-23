package com.amazonas.backend.security.jwt;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

@Service
public class JwtService {

    private static final String SECRET_KEY =
            "amazonas_super_secret_key_2025_backend_jwt_secure_key_must_be_long_enough";

    private static final long EXPIRATION_TIME =
            1000 * 60 * 60 * 24; // 24 horas

    // =========================
    // GENERAR CLAVE
    // =========================

    private SecretKey getSigningKey() {

        byte[] keyBytes = SECRET_KEY.getBytes(StandardCharsets.UTF_8);

        return new SecretKeySpec(
                keyBytes,
                "HmacSHA256"
        );
    }

    // =========================
    // GENERAR TOKEN
    // =========================

    public String generateToken(String email) {

        return Jwts.builder()
                .subject(email)
                .issuedAt(new Date())
                .expiration(
                        new Date(
                                System.currentTimeMillis() + EXPIRATION_TIME
                        )
                )
                .signWith(getSigningKey())
                .compact();
    }

    // =========================
    // EXTRAER EMAIL
    // =========================

    public String extractUsername(String token) {

        return extractAllClaims(token)
                .getSubject();
    }

    // =========================
    // VALIDAR TOKEN
    // =========================

    public boolean isTokenValid(
            String token,
            String email
    ) {

        final String extractedEmail =
                extractUsername(token);

        return extractedEmail.equals(email)
                && !isTokenExpired(token);
    }

    // =========================
    // VALIDAR EXPIRACIÓN
    // =========================

    private boolean isTokenExpired(String token) {

        return extractAllClaims(token)
                .getExpiration()
                .before(new Date());
    }

    // =========================
    // EXTRAER CLAIMS
    // =========================

    private Claims extractAllClaims(String token) {

        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}