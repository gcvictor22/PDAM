package com.salesianostriana.dam.pdam.api.exception.empty;

import javax.persistence.EntityNotFoundException;

public class EmptyDiscothequeListException extends EntityNotFoundException {
    public EmptyDiscothequeListException() {super("No discotheques were found");}
}