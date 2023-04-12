package com.salesianostriana.dam.pdam.api.exception.accesdenied;

import javax.persistence.EntityNotFoundException;

public class EventDeniedAccessException extends EntityNotFoundException {

    public EventDeniedAccessException(){
        super("No tienes permisos para realizar esta acción");
    }

}
