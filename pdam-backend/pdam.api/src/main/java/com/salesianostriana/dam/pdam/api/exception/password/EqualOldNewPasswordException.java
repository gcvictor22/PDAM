package com.salesianostriana.dam.pdam.api.exception.password;

import javax.persistence.EntityNotFoundException;

public class EqualOldNewPasswordException extends EntityNotFoundException {
    public EqualOldNewPasswordException() {
        super("Las contraseña introducida no es correcta, compruebe sus credenciales");
    }
}
