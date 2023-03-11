package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.dyscotkeov1.validation.annotation.user.*;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotEmpty;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldsValueMatch(
        field = "password", fieldMatch = "verifyPassword",
        message = "{newUserDto.password.nomatch}"
)
public class NewUserDto {

    @NotEmpty(message = "{newUserDto.fullname.notempty}")
    private String fullName;

    @NotEmpty(message = "{newUserDto.username.notempty}")
    @UniqueUserName(message = "{newUserDto.username.unique}")
    private String username;

    @NotEmpty(message = "{newUserDto.password.notempty}")
    @StrongPassword
    private String password;

    @NotEmpty(message = "{newUserDto.verifypassword.notempty}")
    private String verifyPassword;

    private String imgPath;

    @NotEmpty(message = "{newUserDto.email.notempty}")
    @Email(message = "{newUserDto.email.email}")
    @UniqueEmail(message = "{newUserDto.email.unique}")
    private String email;

    @NotEmpty(message = "{newUserDto.phone.notEmpty}")
    @UniquePhoneNumber(message = "{newUserDto.phone.unique}")
    @OnlyNumber
    private String phoneNumber;

    private LocalDateTime createdAt = LocalDateTime.now();

}
