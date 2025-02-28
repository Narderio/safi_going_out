insert into user (id, email, name, surname, password, role, status)
    values (99, 'nar@03.com', 'Dario', 'Nardella', 'password', 1, 1);

insert into user (id, email, name, surname, password, role, status)
           values (100, 'nardelladario2003@gmail.com', 'Dario', 'Nardella', 'password', 1, 1);

UPDATE user
SET password = 'password'
WHERE id = 100;