package org.elis.safi_going_out.security;

import org.elis.safi_going_out.repository.UserRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.server.ResponseStatusException;

/**
 * Classe di configurazione per i bean relativi alla sicurezza e all'autenticazione JWT.
 */
@Configuration
public class BeanConfigurazioneJWT {

    private final UserRepository repo;

    /**
     * Costruttore della classe.
     *
     * @param repo Il repository degli utenti.
     */
    public BeanConfigurazioneJWT(UserRepository repo) {
        this.repo = repo;
    }

    /**
     * Crea un bean {@link UserDetailsService} che carica i dettagli dell'utente dal database
     * utilizzando il repository degli utenti.
     *
     * @return Un {@link UserDetailsService} che carica i dettagli dell'utente.
     */
    @Bean
    public UserDetailsService userDetailsService() {
        return username -> repo.getUserByEmail(username)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    }

    /**
     * Crea un bean {@link PasswordEncoder} che utilizza BCrypt per crittografare le password.
     *
     * @return Un {@link PasswordEncoder} che utilizza BCrypt.
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Crea un bean {@link AuthenticationProvider} che utilizza {@link DaoAuthenticationProvider}
     * per autenticare gli utenti.
     *
     * @return Un {@link AuthenticationProvider} che utilizza {@link DaoAuthenticationProvider}.
     */
    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider dap = new DaoAuthenticationProvider();
        dap.setPasswordEncoder(passwordEncoder());
        dap.setUserDetailsService(userDetailsService());
        return dap;
    }

    /**
     * Crea un bean {@link AuthenticationManager} che gestisce l'autenticazione.
     *
     * @param configure La configurazione dell'autenticazione.
     * @return Un {@link AuthenticationManager} che gestisce l'autenticazione.
     * @throws Exception Se si verifica un errore durante la creazione di {@link AuthenticationManager}.
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configure)
            throws Exception {
        return configure.getAuthenticationManager();
    }
}