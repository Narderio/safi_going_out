package org.elis.safi_going_out.repository;

import org.elis.safi_going_out.model.Status;
import org.elis.safi_going_out.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    User getUserById(long id);

    List<User> findAllByStatus(Status status);

    public Optional<User> getUserByEmail(String email);

}
