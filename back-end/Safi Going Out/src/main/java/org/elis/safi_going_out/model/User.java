package org.elis.safi_going_out.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Data
@Entity
public class User {

    @Id
    private long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column
    private String password;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String surname;

    @Column(nullable = false)
    private Role role;

    @Column(nullable = false)
    private Status status;

    @Column(columnDefinition = "LONGTEXT")
    private String image;

    public User(long id, String email, String password, String name, String surname, Role role) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.name = name;
        this.surname = surname;
        this.role = role;
        this.status=Status.IN;
    }

    public User() {

    }
}
