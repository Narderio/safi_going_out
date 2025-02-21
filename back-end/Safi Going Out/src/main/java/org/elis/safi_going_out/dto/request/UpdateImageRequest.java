package org.elis.safi_going_out.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateImageRequest {

    private long id;

    @NotBlank(message = "Il campo 'image' non può essere vuoto")
    private String image;
}
