package com.salesianostriana.dam.pdam.api.exception.empty;

import javax.persistence.EntityNotFoundException;

public class EmptyFestivalListException extends EntityNotFoundException {
    public EmptyFestivalListException(){super("No festivals were found");}
}
