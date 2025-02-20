package org.elis.safi_going_out.handler;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Data
public class ApiError {


    private HttpStatus status;


    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd-MM-yyyy hh:mm:ss")
    private LocalDateTime timestamp;


    Map<String, String> message = new HashMap<>();


    private ApiError() {
        timestamp = LocalDateTime.now();
    }


    public ApiError(HttpStatus status) {
        this();
        this.status = status;
    }


    public void setMethodArgumentNotValidExceptionMessage(MethodArgumentNotValidException e) {
        e.getBindingResult().getFieldErrors().forEach(fe -> {
            message.put(fe.getField(), fe.getDefaultMessage());
        });
    }


    public void setBadRequestExceptionMessage(BadRequestException e) {
        message.put("errore", e.getMessage());
    }
}