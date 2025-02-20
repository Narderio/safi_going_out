package org.elis.safi_going_out.dto.request;

import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import org.elis.safi_going_out.model.Role;

@Data
public class addUserRequest {

    @NotBlank(message="Inserire l'email")
    @Email(message="Inserire un'email valida")
    private String email;

    @NotBlank(message="Inserire la password")
    private String password;

    @NotBlank(message="Confermare la password")
    private String confirmPassword;

    @NotBlank(message="Inserire il nome")
    private String name;

    @NotBlank(message="Inserire il cognome")
    private String surname;

    @Min(value=1, message="Inserire una matricola valida")
    private long matricola;

    @Enumerated(EnumType.STRING)
    private Role role;
}
