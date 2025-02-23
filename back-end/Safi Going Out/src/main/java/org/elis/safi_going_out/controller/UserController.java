package org.elis.safi_going_out.controller;

import jakarta.validation.Valid;
import org.elis.safi_going_out.dto.request.*;
import org.elis.safi_going_out.dto.response.GetUserProfile;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.dto.response.LoginResponse;
import org.elis.safi_going_out.mapper.UserMapper;
import org.elis.safi_going_out.model.User;
import org.elis.safi_going_out.security.TokenUtil;
import org.elis.safi_going_out.service.definition.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class UserController {
    private final UserService userService;
    private final TokenUtil tokenUtil;
    private final UserMapper userMapper;

    public UserController(UserService userService, TokenUtil tokenUtil, UserMapper userMapper) {
        this.userService = userService;
        this.tokenUtil = tokenUtil;
        this.userMapper = userMapper;
    }

    @PostMapping("/addUser")
    public ResponseEntity<User> addUser(@Valid @RequestBody addUserRequest request) {
        User u = userService.addUser(request);
        return ResponseEntity.ok(u);
    }

    @PostMapping("admin/addUserByAdmin")
    public ResponseEntity<User> addUserByAdmin(@Valid @RequestBody addUserByAdminRequest request) {
        User u = userService.addUserByAdmin(request);
        return ResponseEntity.ok(u);
    }

    @PostMapping("admin/deleteUser")
    public ResponseEntity<Boolean> deleteUser(@Valid @RequestBody DeleteUserRequest request){
        Boolean b = userService.deleteUser(request);
        return ResponseEntity.ok(b);
    }


    @GetMapping("admin/getUsers")
    public ResponseEntity<List<GetUsersResponse>> getUsers() {
        List<GetUsersResponse> users = userService.getUsers();
        return ResponseEntity.ok(users);
    }

    @PostMapping("all/userOut")
    public ResponseEntity<Boolean> UserOut(@Valid @RequestBody UserOutRequest request){
        Boolean b = userService.UserOut(request);
        return ResponseEntity.ok(b);
    }

    @PostMapping("all/userIn")
    public ResponseEntity<Boolean> UserIn(@Valid @RequestBody UserInRequest request){
        Boolean b = userService.UserIn(request);
        return ResponseEntity.ok(b);
    }

    @GetMapping("all/getOutUsers")
    public ResponseEntity<List<GetUsersResponse>> getOutUsers() {
        List<GetUsersResponse> users = userService.getOutUsers();
        return ResponseEntity.ok(users);
    }

    @PostMapping("all/getUserById")
    public ResponseEntity<GetUserProfile> getUserById(@RequestBody GetUserProfileRequest request) {
        GetUserProfile u = userService.getUserById(request.getId());
        return ResponseEntity.ok(u);
    }

    @PatchMapping("all/updateEmail")
    public ResponseEntity<Boolean> updateEmail(@Valid @RequestBody UpdateEmailRequest request){
        Boolean b = userService.updateEmail(request);
        return ResponseEntity.ok(b);
    }

    @PatchMapping("all/updateImage")
    public ResponseEntity<Boolean> updateImage(@Valid @RequestBody UpdateImageRequest request){
        Boolean b = userService.updateImage(request);
        return ResponseEntity.ok(b);
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@Valid @RequestBody LoginRequest request){
        User u = userService.login(request);
        String token = tokenUtil.generaToken(u);
        return ResponseEntity.ok(token);
    }

    @PostMapping("all/getUserByToken")
    public ResponseEntity<GetUserProfile> getUserByToken(@RequestBody GetUserByToken request){
        System.out.println(request);
        User u = tokenUtil.getUtenteFromToken(request.getToken());
        System.out.println(u);
        GetUserProfile response = userMapper.toGetUserByIdResponse(u);
        System.out.println(response);
        return ResponseEntity.ok(response);
    }


    @PatchMapping("all/updatePassword")
    public ResponseEntity<Boolean> updatePassword(@Valid @RequestBody UpdatePasswordRequest request){
        Boolean b = userService.updatePassword(request);
        return ResponseEntity.ok(b);
    }

}
