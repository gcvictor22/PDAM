package com.salesianostriana.dam.pdam.api.exception.badrequest;

import javax.persistence.EntityNotFoundException;

public class VerifiactionTokenBadRequestException extends EntityNotFoundException {

    public VerifiactionTokenBadRequestException(int vn){
        super("El código: "+vn+" no es correcto");
    }

}
