package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;

public class DiscothequeNotFoundException extends EntityNotFoundException {

    public DiscothequeNotFoundException(Long id){
        super("No se ha encontrado la discoteca con id: "+id);
    }

}
