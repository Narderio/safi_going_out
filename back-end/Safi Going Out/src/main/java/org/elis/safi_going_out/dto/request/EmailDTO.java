package org.elis.safi_going_out.dto.request;

import lombok.Data;

import java.util.List;

@Data
public class EmailDTO {

    /**
     * La lista dei destinatari dell'email.
     */
    private List<String> destinatario;

    /**
     * L'oggetto dell'email.
     */
    private String oggetto;

    /**
     * Il corpo del testo dell'email.
     */
    private String testo;
}