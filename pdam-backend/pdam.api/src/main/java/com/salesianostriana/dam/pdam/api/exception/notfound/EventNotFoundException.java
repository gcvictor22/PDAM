package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;

public class EventNotFoundException extends EntityNotFoundException {

    public EventNotFoundException(Long id){
        super("No se ha encontrado la discoteca con id: "+id);
    }

}
