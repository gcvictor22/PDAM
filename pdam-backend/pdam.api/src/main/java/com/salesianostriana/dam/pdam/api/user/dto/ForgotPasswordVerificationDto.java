package com.salesianostriana.dam.pdam.api.user.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ForgotPasswordVerificationDto {

    @NotEmpty(message = "{forgotPasswordDto.verificationNumber.notempty}")
    private int verificationNumber;

}
