package com.salesianostriana.dam.pdam.api.exception.stripe;

import javax.persistence.EntityNotFoundException;

public class StripeBadRequestException extends EntityNotFoundException {

    public StripeBadRequestException() {
        super("Ha ocurrido un error en el cliente de stripe");
    }
}
