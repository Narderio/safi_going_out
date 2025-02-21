package org.elis.safi_going_out.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.elis.safi_going_out.model.User;
import org.elis.safi_going_out.service.definition.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;

/**
 * Classe di utilità per la gestione dei token JWT.
 * Fornisce metodi per generare, validare e estrarre informazioni dai token.
 */
@Service
public class TokenUtil {

    @Autowired
    private UserService service;

    @Value("${chiave.jwt.key}")
    private String key;

    /**
     * Genera la chiave segreta per la firma e la verifica dei token JWT.
     *
     * @return La chiave segreta.
     */
    private SecretKey generaChiave() {
        return Keys.hmacShaKeyFor(key.getBytes());
    }

    /**
     * Genera un token JWT per l'utente specificato.
     *
     * @param u L'utente per cui generare il token.
     * @return Il token JWT generato.
     */
    public String generaToken(User u) {
        String username = u.getEmail();

        // Calcola la data di scadenza del token (1 anno da adesso)
        long millisecondiDiDurata = 1000L * 60 * 60 * 24 * 365;
        return Jwts.builder()
                .setSubject(username) // Imposta il subject del token (l'email dell'utente)
                .issuedAt(new Date(System.currentTimeMillis())) // Imposta la data di emissione del token
                .expiration(new Date(System.currentTimeMillis() + millisecondiDiDurata)) // Imposta la data di scadenza del token
                .signWith(generaChiave()) // Firma il token con la chiave segreta
                .compact(); // Genera il token in formato compatto
    }

    /**
     * Estrae i claims (informazioni) dal token JWT.
     *
     * @param token Il token JWT.
     * @return I claims del token.
     */
    private Claims prendiClaimsDalToken(String token) {
        JwtParser parser = Jwts.parser()
                .verifyWith(generaChiave()) // Verifica la firma del token con la chiave segreta
                .build();
        return parser.parseSignedClaims(token) // Estrae i claims dal token
                .getPayload();
    }

    /**
     * Estrae il subject (email dell'utente) dal token JWT.
     *
     * @param token Il token JWT.
     * @return Il subject del token.
     */
    public String getSubject(String token) {
        return prendiClaimsDalToken(token).getSubject();
    }

    /**
     * Estrae l'utente dal token JWT.
     *
     * @param token Il token JWT.
     * @return L'utente corrispondente al token.
     */
    public User getUtenteFromToken(String token) {
        System.out.println("Token: " + token);
        String username = getSubject(token);
        System.out.println("Username: " + username);
        return service.getUserByEmail(username); // Carica l'utente dal database in base all'email
    }
}