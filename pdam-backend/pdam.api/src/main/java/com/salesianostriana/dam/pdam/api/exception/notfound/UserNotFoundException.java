package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;
import java.util.UUID;

public class UserNotFoundException extends EntityNotFoundException {

    public UserNotFoundException(UUID id){
        super(String.format("The user with id: "+id+" does not exist"));
    }

    public UserNotFoundException(String username){
        super(String.format("The user: "+username+" does not exist"));
    }

}
