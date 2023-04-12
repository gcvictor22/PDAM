package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;

public class CityNotFoundException extends EntityNotFoundException {

    public CityNotFoundException(Long id){
        super("No se ha encontrado la ciudad con id: "+id);
    }

}
