package com.salesianostriana.dam.pdam.api.exception.accesdenied;

import javax.persistence.EntityNotFoundException;

public class PostAccessDeniedExeption extends EntityNotFoundException {
    public PostAccessDeniedExeption(){super("No tienes permiso para modificar una publicación de otro usuario");}
}
