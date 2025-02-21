package org.elis.safi_going_out.controller;

import jakarta.validation.Valid;
import org.elis.safi_going_out.dto.request.*;
import org.elis.safi_going_out.dto.response.GetUserProfile;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.model.User;
import org.elis.safi_going_out.service.definition.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class UserController {
    private final UserService userService;


    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/addUser")
    public ResponseEntity<User> addUser(@Valid @RequestBody addUserRequest request) {
        User u = userService.addUser(request);
        return ResponseEntity.ok(u);
    }

    @PostMapping("/addUserByAdmin")
    public ResponseEntity<User> addUserByAdmin(@Valid @RequestBody addUserByAdminRequest request) {
        User u = userService.addUserByAdmin(request);
        return ResponseEntity.ok(u);
    }

    @PostMapping("/deleteUser")
    public ResponseEntity<Boolean> deleteUser(@Valid @RequestBody DeleteUserRequest request){
        Boolean b = userService.deleteUser(request);
        return ResponseEntity.ok(b);
    }


    @GetMapping("/getUsers")
    public ResponseEntity<List<GetUsersResponse>> getUsers() {
        List<GetUsersResponse> users = userService.getUsers();
        return ResponseEntity.ok(users);
    }

    @PostMapping("/userOut")
    public ResponseEntity<Boolean> UserOut(@Valid @RequestBody UserOutRequest request){
        Boolean b = userService.UserOut(request);
        return ResponseEntity.ok(b);
    }

    @PostMapping("/userIn")
    public ResponseEntity<Boolean> UserIn(@Valid @RequestBody UserInRequest request){
        Boolean b = userService.UserIn(request);
        return ResponseEntity.ok(b);
    }

    @GetMapping("/getOutUsers")
    public ResponseEntity<List<GetUsersResponse>> getOutUsers() {
        List<GetUsersResponse> users = userService.getOutUsers();
        return ResponseEntity.ok(users);
    }

    @PostMapping("/getUserById")
    public ResponseEntity<GetUserProfile> getUserById(@RequestBody GetUserProfileRequest request) {
        GetUserProfile u = userService.getUserById(request.getId());
        return ResponseEntity.ok(u);
    }

    @PatchMapping("/updateEmail")
    public ResponseEntity<Boolean> updateEmail(@Valid @RequestBody UpdateEmailRequest request){
        Boolean b = userService.updateEmail(request);
        return ResponseEntity.ok(b);
    }

    @PatchMapping("/updateImage")
    public ResponseEntity<Boolean> updateImage(@Valid @RequestBody UpdateImageRequest request){
        Boolean b = userService.updateImage(request);
        return ResponseEntity.ok(b);
    }


}
