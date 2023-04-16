package com.salesianostriana.dam.pdam.api.exception.token;

import com.salesianostriana.dam.pdam.api.exception.token.JwtTokenException;

public class RefreshTokenException extends JwtTokenException {

    public RefreshTokenException(String msg) {
        super(msg);
    }

}


