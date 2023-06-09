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
public class ForgotPasswordDto {

    @NotEmpty(message = "{forgotPasswordDto.userName.notempty}")
    private String userName;

}
