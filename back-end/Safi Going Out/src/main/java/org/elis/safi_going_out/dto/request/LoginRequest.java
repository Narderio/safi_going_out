package org.elis.safi_going_out.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {

    @Email(message = "Il campo 'email' deve essere un indirizzo email valido")
    private String email;

    @NotBlank(message = "Il campo 'password' non può essere nullo o vuoto")
    private String password;
}
