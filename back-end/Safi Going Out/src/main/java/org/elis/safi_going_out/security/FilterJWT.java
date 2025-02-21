package org.elis.safi_going_out.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.elis.safi_going_out.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Filtro che intercetta le richieste HTTP e verifica la presenza di un token JWT valido nell'header "Authorization".
 * Se il token è valido, estrae l'utente dal token e lo autentica nel contesto di sicurezza di Spring.
 */
@Component
public class FilterJWT extends OncePerRequestFilter {

    @Autowired
    private TokenUtil tokenUtil;

    /**
     * Esegue il filtro sulla richiesta HTTP.
     *
     * @param request     La richiesta HTTP.
     * @param response    La risposta HTTP.
     * @param filterChain La catena di filtri.
     * @throws ServletException Se si verifica un errore durante l'elaborazione della richiesta.
     * @throws IOException      Se si verifica un errore di input/output.
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        System.out.println("Filtro JWT");
        String authCode = request.getHeader("Authorization");
        if (authCode != null && authCode.startsWith("Bearer ")) {
            String token = authCode.substring(7); // Rimuove il prefisso "Bearer "
            User u = tokenUtil.getUtenteFromToken(token); // Estrae l'utente dal token
            UsernamePasswordAuthenticationToken upat =
                    new UsernamePasswordAuthenticationToken(u, null, u.getAuthorities()); // Crea un token di autenticazione
            upat.setDetails(new WebAuthenticationDetailsSource().buildDetails(request)); // Imposta i dettagli dell'autenticazione
            SecurityContextHolder.getContext().setAuthentication(upat); // Autentica l'utente nel contesto di sicurezza
        }
        filterChain.doFilter(request, response); // Passa la richiesta al filtro successivo nella catena
    }
}