package com.salesianostriana.dam.pdam.api.exception.empty;

import javax.persistence.EntityNotFoundException;

public class EmptyUserListException extends EntityNotFoundException {

    public EmptyUserListException(){
        super("No users were found");
    }

}
