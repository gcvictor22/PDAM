package com.salesianostriana.dam.pdam.api.verificationtoken.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetVerificationTokenDto {

    @NotEmpty(message = "{forgotPasswordDto.userName.notempty}")
    private String userName;

    @NotNull(message = "{forgotPasswordDto.verificationNumber.notempty}")
    private int verificationNumber;

}
