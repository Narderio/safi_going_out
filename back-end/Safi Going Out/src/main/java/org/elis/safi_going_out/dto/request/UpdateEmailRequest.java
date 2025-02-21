package org.elis.safi_going_out.dto.request;

import jakarta.validation.constraints.Email;
import lombok.Data;

@Data
public class UpdateEmailRequest {

    private long id;

    @Email(message = "Il campo 'email' deve essere un indirizzo email valido")
    private String email;
}
