package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.pdam.api.validation.annotation.user.FieldsValueMatch;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.StrongPassword;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldsValueMatch(
        field = "newPassword", fieldMatch = "newPasswordVerify",
        message = "{newUserDto.password.nomatch}"
)
public class ForgotPasswordChangeDto {

    @NotEmpty(message = "{changePasswordDto.newPassword.notEmpty}")
    @StrongPassword
    private String newPassword;

    @NotEmpty(message = "{changePasswordDto.verifypassword.notempty}")
    private String newPasswordVerify;

}
