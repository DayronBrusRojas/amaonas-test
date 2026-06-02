package com.amazonas.backend.modules.auth.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.amazonas.backend.modules.auth.service.EmailService;

import jakarta.mail.internet.MimeMessage;

@Service
public class EmailServiceImpl implements EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailServiceImpl.class);

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Value("${app.frontend.url:http://localhost:4200}")
    private String frontendUrl;

    public EmailServiceImpl(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Override
    public void sendPasswordResetEmail(String toEmail, String token, String name) {
        String resetLink = frontendUrl + "/reset-password?token=" + token;
        log.info("Generando correo de recuperacion para {} con link: {}", toEmail, resetLink);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail, "Maquetas Educativas Amazonas");
            helper.setTo(toEmail);
            helper.setSubject("Recuperación de Contraseña - Amazonas");

            String htmlBody = "<div style=\"font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px; background-color: #ffffff;\">"
                    + "  <div style=\"text-align: center; margin-bottom: 20px;\">"
                    + "    <h2 style=\"color: #2b6cb0; margin: 0; font-size: 26px; font-weight: 700;\">AMAZONAS</h2>"
                    + "    <p style=\"color: #718096; margin: 5px 0 0 0; font-size: 14px;\">Maquetas Educativas Creativas</p>"
                    + "  </div>"
                    + "  <hr style=\"border: none; border-top: 1px solid #e2e8f0; margin-bottom: 20px;\" />"
                    + "  <div style=\"color: #2d3748; font-size: 16px; line-height: 1.6;\">"
                    + "    <p>¡Hola <strong>" + name + "</strong>!</p>"
                    + "    <p>Hemos recibido una solicitud para restablecer la contraseña de tu cuenta asociada a este correo electrónico.</p>"
                    + "    <p>Para continuar con el proceso, haz clic en el siguiente botón seguro (este enlace expira en <strong>15 minutos</strong>):</p>"
                    + "    <div style=\"text-align: center; margin: 30px 0;\">"
                    + "      <a href=\"" + resetLink + "\" style=\"display: inline-block; padding: 12px 28px; background-color: #3182ce; color: #ffffff; text-decoration: none; border-radius: 5px; font-weight: 600; font-size: 16px; box-shadow: 0 4px 6px -1px rgba(49, 130, 206, 0.4); transition: background-color 0.2s;\">Restablecer Contraseña</a>"
                    + "    </div>"
                    + "    <p style=\"color: #718096; font-size: 14px;\">Si no puedes hacer clic en el botón, copia y pega el siguiente enlace en tu navegador:</p>"
                    + "    <p style=\"word-break: break-all; font-size: 14px; color: #3182ce;\"><a href=\"" + resetLink + "\">" + resetLink + "</a></p>"
                    + "    <p style=\"margin-top: 20px; font-size: 14px; color: #e53e3e;\"><strong>Nota:</strong> Si tú no solicitaste este cambio, puedes ignorar este mensaje de forma segura. Tu contraseña actual no sufrirá ningún cambio.</p>"
                    + "  </div>"
                    + "  <hr style=\"border: none; border-top: 1px solid #e2e8f0; margin: 30px 0 20px 0;\" />"
                    + "  <div style=\"text-align: center; color: #a0aec0; font-size: 12px;\">"
                    + "    <p>© 2026 Amazonas. Todos los derechos reservados.</p>"
                    + "  </div>"
                    + "</div>";

            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("Correo de recuperacion enviado exitosamente a {}", toEmail);

        } catch (Exception e) {
            log.error("Error al enviar el correo de recuperacion a {}: {}", toEmail, e.getMessage(), e);
            throw new RuntimeException("No se pudo enviar el correo de recuperación. Inténtalo de nuevo más tarde.");
        }
    }
}
