package org.elis.safi_going_out.dto.response;

import lombok.Data;

@Data
public class GetUserProfile {

    private long id;
    private String name;
    private String surname;
    private String email;
    private String role;
    private String image;
}
