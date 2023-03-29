package com.salesianostriana.dam.pdam.api.exception.badrequest;

import javax.persistence.EntityNotFoundException;

public class VerificationTokenExpirationTimeBadRequestException extends EntityNotFoundException {
    public VerificationTokenExpirationTimeBadRequestException(){
        super("El código de verificación ha expirado");
    }
}
