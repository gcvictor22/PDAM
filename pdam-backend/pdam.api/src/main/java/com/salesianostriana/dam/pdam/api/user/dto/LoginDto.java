package com.salesianostriana.dam.pdam.api.user.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginDto {

    @NotEmpty(message = "{newUserDto.username.notempty}")
    private String username;

    @NotEmpty(message = "{newUserDto.password.notempty}")
    private String password;

}
