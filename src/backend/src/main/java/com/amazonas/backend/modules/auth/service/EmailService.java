package com.amazonas.backend.modules.auth.service;

public interface EmailService {
    void sendPasswordResetEmail(String toEmail, String token, String name);
}
