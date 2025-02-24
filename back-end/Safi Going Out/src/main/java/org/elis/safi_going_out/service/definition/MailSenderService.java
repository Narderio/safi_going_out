package org.elis.safi_going_out.service.definition;


import org.elis.safi_going_out.dto.request.EmailDTO;
import org.elis.safi_going_out.model.User;
import org.springframework.stereotype.Service;


public interface MailSenderService {

    void inviaMessaggio(EmailDTO emailDTO);

    void addUser(User u);

}
