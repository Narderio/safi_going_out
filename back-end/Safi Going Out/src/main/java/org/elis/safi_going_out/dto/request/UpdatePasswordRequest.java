package org.elis.safi_going_out.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UpdatePasswordRequest {

    @Min(value = 1, message = "La matricola deve essere valida")
    private long id;

    @NotBlank(message = "La vecchia password non può essere vuota")
    private String oldPassword;

    @NotBlank(message = "La nuova password non può essere vuota")
    @Size(min = 8, message = "La nuova password deve essere lunga almeno 8 caratteri")
    private String newPassword;

    @NotBlank(message = "La conferma della nuova password non può essere vuota")
    private String confirmPassword;
}
