package org.elis.safi_going_out.service.definition;

import jakarta.validation.Valid;
import org.elis.safi_going_out.dto.request.*;
import org.elis.safi_going_out.dto.response.GetUserProfile;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.model.User;

import java.util.List;

public interface UserService{

    public User addUser(addUserRequest request);

    public List<GetUsersResponse> getUsers();

    public User addUserByAdmin(@Valid addUserByAdminRequest request);

    public boolean UserOut(@Valid UserOutRequest request);

    public boolean UserIn(@Valid UserInRequest request);

    public List<GetUsersResponse> getOutUsers();

    public Boolean deleteUser(@Valid DeleteUserRequest request);

    public GetUserProfile getUserById(Long id);

    public Boolean updateEmail(@Valid UpdateEmailRequest request);

    public Boolean updateImage(@Valid UpdateImageRequest request);

    public User login(@Valid LoginRequest request);

    public User getUserByEmail(String email);

    public Boolean updatePassword(@Valid UpdatePasswordRequest request);
}
