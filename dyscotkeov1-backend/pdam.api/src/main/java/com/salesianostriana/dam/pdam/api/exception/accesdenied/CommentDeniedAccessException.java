package com.salesianostriana.dam.pdam.api.exception.accesdenied;

import javax.persistence.EntityNotFoundException;

public class CommentDeniedAccessException extends EntityNotFoundException {
    public CommentDeniedAccessException(){
        super("No tienes permiso para modificar un comentario de otro usuario");
    }
}
