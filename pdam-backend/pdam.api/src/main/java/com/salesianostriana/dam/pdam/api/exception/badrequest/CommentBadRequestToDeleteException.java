package com.salesianostriana.dam.pdam.api.exception.badrequest;

import javax.persistence.EntityNotFoundException;

public class CommentBadRequestToDeleteException extends EntityNotFoundException {
    public CommentBadRequestToDeleteException(Long id){
        super("No se ha encotrado un Comentario con el id: "+id);
    }
}
