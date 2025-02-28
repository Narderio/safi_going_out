package org.elis.safi_going_out.service.implementation;

import jakarta.validation.Valid;
import org.elis.safi_going_out.dto.request.*;
import org.elis.safi_going_out.dto.response.GetUserProfile;
import org.elis.safi_going_out.dto.response.GetUsersResponse;
import org.elis.safi_going_out.handler.BadRequestException;
import org.elis.safi_going_out.mapper.UserMapper;
import org.elis.safi_going_out.model.Role;
import org.elis.safi_going_out.model.Status;
import org.elis.safi_going_out.model.User;
import org.elis.safi_going_out.repository.UserRepository;
import org.elis.safi_going_out.service.definition.MailSenderService;
import org.elis.safi_going_out.service.definition.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final MailSenderService mailService;

    public UserServiceImpl(UserRepository userRepository, UserMapper userMapper, PasswordEncoder passwordEncoder, MailSenderService mailService) {
        this.userRepository = userRepository;
        this.userMapper = userMapper;
        this.passwordEncoder = passwordEncoder;
        this.mailService = mailService;
    }

    @Override
    public User addUser(addUserRequest request) {

        if (!request.getPassword().equals(request.getConfirmPassword()))
            throw new BadRequestException("Le password non coincidono");

        User user = userRepository.getUserById(request.getMatricola());
        if (user != null)
            throw new BadRequestException("Utente già registrato");

        Optional<User> user2 = userRepository.getUserByEmail(request.getEmail());
        if (user2.isPresent())
            throw new BadRequestException("Email già registrata");

        User user1 = new User(request.getMatricola(), request.getEmail(), request.getPassword(), request.getName(), request.getSurname(), Role.USER);
        user1.setStatus(Status.IN);
        userRepository.save(user1);

        return user1;
    }

    @Override
    public List<GetUsersResponse> getUsers() {
        List<User> users = userRepository.findAll();
        List<GetUsersResponse> response = userMapper.toGetUsersResponse(users);
        return response;
    }

    @Override
    public User addUserByAdmin(addUserByAdminRequest request) {
        User user = userRepository.getUserById(request.getId());
        if (user != null)
            throw new BadRequestException("Utente già registrato");

        Optional<User> user2 = userRepository.getUserByEmail(request.getEmail());
        if (user2.isPresent())
            throw new BadRequestException("Email già registrata");

        try {
            String uuid = UUID.randomUUID().toString();
            String passwordGenerata = uuid.replace("-", "").substring(0, 12);

            //TODO password encoder
            String passwordGenerataHashata = passwordEncoder.encode(passwordGenerata);


            User user1 = new User(request.getId(), request.getEmail(), passwordGenerata, request.getName(), request.getSurname(), request.getRole());
            user1.setStatus(Status.IN);
            mailService.addUser(user1);
            userRepository.save(user1);

            return user1;
        } catch (Exception e) {
            throw new BadRequestException("Errore nell'invio della mail");
        }


    }

    public boolean UserOut(@Valid UserOutRequest request) {

        User user = userRepository.getUserById(request.getId());
        if (user == null)
            throw new BadRequestException("Utente non trovato");

        user.setStatus(Status.OUT);
        userRepository.save(user);
        return true;
    }

    public boolean UserIn(@Valid UserInRequest request) {
        User user = userRepository.getUserById(request.getId());
        if (user == null)
            throw new BadRequestException("Utente non trovato");

        user.setStatus(Status.IN);
        userRepository.save(user);
        return true;
    }

    @Override
    public List<GetUsersResponse> getOutUsers() {
        List<User> users = userRepository.findAllByStatus(Status.OUT);
        return userMapper.toGetUsersResponse(users);
    }

    @Override
    public Boolean deleteUser(@Valid DeleteUserRequest request) {
        User user = userRepository.getUserById(request.getId());
        if (user == null)
            throw new BadRequestException("Utente non trovato");

        userRepository.delete(user);
        return true;
    }

    @Override
    public GetUserProfile getUserById(Long id) {
        User user = userRepository.getUserById(id);
        if (user == null)
            throw new BadRequestException("Utente non trovato");
        return userMapper.toGetUserByIdResponse(user);
    }

    public Boolean updateEmail(@Valid UpdateEmailRequest request) {
        User user = userRepository.getUserById(request.getId());
        if (user == null)
            throw new BadRequestException("Utente non trovato");
        if (userRepository.getUserByEmail(request.getEmail()).isPresent())
            throw new BadRequestException("Email già registrata");

        user.setEmail(request.getEmail());
        userRepository.save(user);
        return true;
    }

    public Boolean updateImage(@Valid UpdateImageRequest request) {
        User user = userRepository.getUserById(request.getId());
        if (user == null)
            throw new BadRequestException("Utente non trovato");

        user.setImage(request.getImage());
        userRepository.save(user);
        return true;
    }

    public User login(@Valid LoginRequest request) {
        Optional<User> user = userRepository.getUserByEmail(request.getEmail());
        if (user.isEmpty())
            throw new BadRequestException("Utente non trovato");

        if (!user.get().getPassword().equals(request.getPassword()))
            throw new BadRequestException("Password errata");

        return user.get();
    }

    public User getUserByEmail(String email) {
        Optional<User> user = userRepository.getUserByEmail(email);
        if (user.isEmpty())
            throw new BadRequestException("Utente non trovato");
        return user.get();
    }

    public Boolean updatePassword(@Valid UpdatePasswordRequest request) {
        User user = userRepository.getUserById(request.getId());
        if (user == null)
            throw new BadRequestException("Utente non trovato");

        if (!request.getNewPassword().equals(request.getConfirmPassword()))
            throw new BadRequestException("Le password non coincidono");

        if (!user.getPassword().equals(request.getOldPassword()))
            throw new BadRequestException("Password errata");

        user.setPassword(request.getNewPassword());
        userRepository.save(user);
        return true;
    }

    public Boolean forgotPassword(ForgotPasswordRequest request) {
        Optional<User> user = userRepository.getUserByEmail(request.getEmail());
        if (user.isEmpty())
            throw new BadRequestException("Utente non trovato");

        String uuid = UUID.randomUUID().toString();
        String passwordGenerata = uuid.replace("-", "").substring(0, 12);

        //TODO password encoder
        String passwordGenerataHashata = passwordEncoder.encode(passwordGenerata);

        user.get().setPassword(passwordGenerataHashata);

        try {
            mailService.forgotPassword(user.get(), passwordGenerata);
            userRepository.save(user.get());
        } catch (Exception e) {
            throw new BadRequestException("Errore nell'invio della mail");
        }

        return true;
    }


}
