package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;

public class GenderNotFoundException extends EntityNotFoundException {

    public GenderNotFoundException(Long id){
        super("No se ha encontrado ningún género con id: "+id);
    }

}
