package org.elis.safi_going_out.dto.response;

import lombok.Data;
import org.elis.safi_going_out.model.Role;

@Data
public class GetUsersResponse {

    private long id;
    private String name;
    private String surname;
    private Role role;
    private String image;
}
