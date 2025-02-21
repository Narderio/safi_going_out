package org.elis.safi_going_out.security;

import org.elis.safi_going_out.model.Role;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Classe di configurazione per la sicurezza web.
 * Definisce la catena di filtri di sicurezza e le regole di autorizzazione per le diverse richieste HTTP.
 */
@Configuration
@EnableWebSecurity
public class GestoreFilterChain {

    private final FilterJWT filterJwt;
    private final AuthenticationProvider provider;

    /**
     * Costruttore della classe.
     *
     * @param filterJwt Il filtro JWT per l'autenticazione.
     * @param provider  Il provider di autenticazione.
     */
    public GestoreFilterChain(FilterJWT filterJwt, AuthenticationProvider provider) {
        this.filterJwt = filterJwt;
        this.provider = provider;
    }

    /**
     * Crea un bean {@link SecurityFilterChain} che definisce la catena di filtri di sicurezza.
     *
     * @param httpSecurity L'oggetto {@link HttpSecurity} per configurare la sicurezza web.
     * @return Un {@link SecurityFilterChain} che definisce la catena di filtri di sicurezza.
     * @throws Exception Se si verifica un errore durante la configurazione della sicurezza.
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        System.out.println("securityFilterChain");
        httpSecurity.csrf(AbstractHttpConfigurer::disable) // Disabilita la protezione CSRF
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/login").permitAll() // Permette a tutti di accedere al endpoint /login
                        .requestMatchers("/all/**").permitAll() // Permette a tutti di accedere agli endpoint /all/**
                        .requestMatchers("/admin/**").hasRole(Role.ADMIN.toString()) // Richiede l'autorizzazione dell'utente con ruolo ADMIN per accedere agli endpoint /admin/**
                        .requestMatchers("/user/**").hasRole(Role.USER.toString()) // Richiede l'autorizzazione dell'utente con ruolo USER per accedere agli endpoint /user/**
                        .anyRequest().permitAll() // Nega tutte le altre richieste
                ).sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // Disabilita la gestione delle sessioni
                .cors(AbstractHttpConfigurer::disable) // Disabilita CORS
                .authenticationProvider(provider) // Imposta il provider di autenticazione
                .addFilterBefore(filterJwt, UsernamePasswordAuthenticationFilter.class);// Aggiunge il filtro JWT prima del filtro di autenticazione standard
        return httpSecurity.build();
    }

}