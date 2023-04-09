package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;

public class PartyNotFoundException extends EntityNotFoundException {

    public PartyNotFoundException(Long id){
        super("No se ha encontrado ninguna fiesta con el id:"+id);
    }

}
