package com.salesianostriana.dam.pdam.api.exception.token;

import org.springframework.security.access.AccessDeniedException;

public class JwtTokenException extends AccessDeniedException {

    public JwtTokenException(String msg) {
        super(msg);
    }


}
