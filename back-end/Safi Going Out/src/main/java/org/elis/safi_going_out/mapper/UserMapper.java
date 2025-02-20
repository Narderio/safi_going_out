package org.elis.safi_going_out.mapper;

import lombok.Data;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.model.User;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class UserMapper {

    public List<GetUsersResponse> toGetUsersResponse(List<User> users) {
        List<GetUsersResponse> response = new ArrayList<>();
        for(User u : users){
            GetUsersResponse u1 = new GetUsersResponse();
            u1.setId(u.getId());
            u1.setName(u.getName());
            u1.setSurname(u.getSurname());
            u1.setRole(u.getRole());
            response.add(u1);
        }
        return response;
    }

}
