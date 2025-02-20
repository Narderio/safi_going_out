package org.elis.safi_going_out.service.implementation;

import jakarta.validation.Valid;
import org.elis.safi_going_out.dto.request.*;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.handler.BadRequestException;
import org.elis.safi_going_out.mapper.UserMapper;
import org.elis.safi_going_out.model.Status;
import org.elis.safi_going_out.model.User;
import org.elis.safi_going_out.repository.UserRepository;
import org.elis.safi_going_out.service.definition.UserService;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public UserServiceImpl(UserRepository userRepository, UserMapper userMapper) {
        this.userRepository = userRepository;
        this.userMapper = userMapper;
    }

    @Override
    public User addUser(addUserRequest request) {

        if(!request.getPassword().equals(request.getConfirmPassword()))
            throw new BadRequestException("Le password non coincidono");

        User user = userRepository.getUserById(request.getMatricola());
        if(user != null)
            throw new BadRequestException("Utente già registrato");

        User user1 = new User(request.getMatricola(), request.getEmail(), request.getPassword(), request.getName(), request.getSurname(), request.getRole());
        user1.setStatus(Status.IN);
        userRepository.save(user1);

        return user1;
    }

    @Override
    public List<GetUsersResponse> getUsers() {
        List<User> users= userRepository.findAll();
        List<GetUsersResponse> response = userMapper.toGetUsersResponse(users);
        return response;
    }

    @Override
    public User addUserByAdmin(addUserByAdminRequest request) {
        User user = userRepository.getUserById(request.getId());
        if(user != null)
            throw new BadRequestException("Utente già registrato");

        String password = "password";

        User user1 = new User(request.getId(), request.getEmail(), password, request.getName(), request.getSurname(), request.getRole());
        user1.setStatus(Status.IN);
        userRepository.save(user1);
        return user1;
    }

    public boolean UserOut(@Valid UserOutRequest request){

        User user = userRepository.getUserById(request.getId());
        if(user == null)
            throw new BadRequestException("Utente non trovato");

        user.setStatus(Status.OUT);
        userRepository.save(user);
        return true;
    }

    public boolean UserIn(@Valid UserInRequest request){
        User user = userRepository.getUserById(request.getId());
        if(user == null)
            throw new BadRequestException("Utente non trovato");

        user.setStatus(Status.IN);
        userRepository.save(user);
        return true;
    }

    @Override
    public List<GetUsersResponse> getOutUsers() {
        List<User> users= userRepository.findAllByStatus(Status.OUT);
        return userMapper.toGetUsersResponse(users);
    }

    @Override
    public Boolean deleteUser(@Valid DeleteUserRequest request){
        User user = userRepository.getUserById(request.getId());
        if(user == null)
            throw new BadRequestException("Utente non trovato");

        userRepository.delete(user);
        return true;
    }

}
