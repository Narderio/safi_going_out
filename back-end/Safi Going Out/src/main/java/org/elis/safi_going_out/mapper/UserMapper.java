package org.elis.safi_going_out.mapper;

import org.elis.safi_going_out.dto.response.GetUserProfile;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.dto.response.LoginResponse;
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
            if(u.getImage()==null)
                u1.setImage("");
            else
                u1.setImage(u.getImage());
        }
        return response;
    }

    public GetUserProfile toGetUserByIdResponse(User user) {
        GetUserProfile response = new GetUserProfile();
        response.setId(user.getId());
        response.setName(user.getName());
        response.setSurname(user.getSurname());
        response.setRole(user.getRole().toString());
        response.setEmail(user.getEmail());
        if(user.getImage()==null)
            response.setImage("");
        else
            response.setImage(user.getImage());
        return response;
    }

}
