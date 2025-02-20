package org.elis.safi_going_out.dto.request;

import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import org.elis.safi_going_out.model.Role;

@Data
public class addUserByAdminRequest {

    @NotBlank(message = "Il campo 'name' non può essere nullo o vuoto")
    private String name;

    @NotBlank(message = "Il campo 'surname' non può essere nullo o vuoto")
    private String surname;

    @Email(message = "Il campo 'email' deve essere un indirizzo email valido")
    private String email;

    @Min(value = 1, message = "La matricola non può essere nullo o minore di 1")
    private long id;

    @Enumerated(EnumType.STRING)
    private Role role;
}
