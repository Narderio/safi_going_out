package org.elis.safi_going_out.handler;

public class BadRequestException extends RuntimeException {

    public BadRequestException(String message) {
        super(message);
    }
}