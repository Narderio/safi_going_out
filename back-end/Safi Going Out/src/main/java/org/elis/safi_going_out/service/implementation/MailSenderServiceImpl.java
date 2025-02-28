package org.elis.safi_going_out.service.implementation;

import org.elis.safi_going_out.dto.request.EmailDTO;
import org.elis.safi_going_out.model.User;
import org.elis.safi_going_out.service.definition.MailSenderService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MailSenderServiceImpl implements MailSenderService {

    @Value("${spring.mail.username}")
    private String mittente;


    private final JavaMailSender sender;

    public MailSenderServiceImpl(JavaMailSender sender) {
        this.sender = sender;
    }



    @Override
    @Async
    public void inviaMessaggio(EmailDTO emailDTO) {
        SimpleMailMessage messaggio = new SimpleMailMessage();
        messaggio.setFrom(mittente);
        messaggio.setTo(emailDTO.getDestinatario().toArray(new String[0])); // Converte la lista di destinatari in un array di stringhe
        messaggio.setSubject(emailDTO.getOggetto());
        messaggio.setText(emailDTO.getTesto());
        sender.send(messaggio);
    }

    @Override
    public void addUser(User u){
        String mailText= "Benvenuto "+u.getName()+" "+u.getSurname()+"\n"
                + "La tua email è: "+u.getEmail()+"\n"
                + "La tua password è: " + u.getPassword();
        try {
            EmailDTO emailDTO = new EmailDTO();
            emailDTO.setDestinatario(List.of(u.getEmail()));
            emailDTO.setOggetto("Registrazione");
            emailDTO.setTesto(mailText);
            inviaMessaggio(emailDTO);
        } catch (Exception e) {
            throw new RuntimeException("Errore nell'invio della mail");
        }
    }

    @Override
    @Async
    public void forgotPassword(User user, String passwordGenerata){
        String mailText= "Ciao "+user.getName()+" "+user.getSurname()+"\n"
                + "La tua nuova password è: " + passwordGenerata;
        try {
            EmailDTO emailDTO = new EmailDTO();
            emailDTO.setDestinatario(List.of(user.getEmail()));
            emailDTO.setOggetto("Password dimenticata");
            emailDTO.setTesto(mailText);
            inviaMessaggio(emailDTO);
        } catch (Exception e) {
            throw new RuntimeException("Errore nell'invio della mail");
        }
    }




}
