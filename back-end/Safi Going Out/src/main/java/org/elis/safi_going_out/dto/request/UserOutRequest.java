package org.elis.safi_going_out.dto.request;

import jakarta.validation.constraints.Min;
import lombok.Data;

@Data
public class UserOutRequest {

    @Min(value = 1, message = "L'id dell'utente non può essere nullo o minore di 1")
    private long id;
}
