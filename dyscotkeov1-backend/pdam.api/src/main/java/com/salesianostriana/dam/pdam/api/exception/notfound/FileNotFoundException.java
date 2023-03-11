package com.salesianostriana.dam.pdam.api.exception.notfound;

import javax.persistence.EntityNotFoundException;

public class FileNotFoundException extends EntityNotFoundException {
    public FileNotFoundException (String img){
        super("No se ha encontrado la imagen: "+img);
    }
}
