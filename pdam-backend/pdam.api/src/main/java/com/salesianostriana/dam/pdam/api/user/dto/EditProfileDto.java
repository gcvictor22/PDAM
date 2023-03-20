package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.pdam.api.validation.annotation.user.OnlyNumber;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniqueEmail;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniquePhoneNumber;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniqueUserName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EditProfileDto {

    @NotEmpty(message = "{newUserDto.fullname.notempty}")
    private String fullName;

    @NotEmpty(message = "{newUserDto.username.notempty}")
    @UniqueUserName(message = "{newUserDto.username.unique}")
    private String username;

    @NotEmpty(message = "{newUserDto.email.notempty}")
    @Email(message = "{newUserDto.email.email}")
    @UniqueEmail(message = "{newUserDto.email.unique}")
    private String email;

    @NotEmpty(message = "{newUserDto.phone.notEmpty}")
    @UniquePhoneNumber(message = "{newUserDto.phone.unique}")
    @OnlyNumber
    private String phoneNumber;

}
