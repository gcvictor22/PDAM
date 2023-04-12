package com.salesianostriana.dam.pdam.api.exception.empty;

import javax.persistence.EntityNotFoundException;

public class EmptyEventListException extends EntityNotFoundException {

    public EmptyEventListException(){ super("No events were found"); }

}
