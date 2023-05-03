package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniqueUserName;
import lombok.*;

import javax.validation.constraints.NotEmpty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EditUserNameDto {

    @NotEmpty(message = "{newUserDto.username.notempty}")
    @UniqueUserName(message = "{newUserDto.username.unique}")
    private String userName;

}
