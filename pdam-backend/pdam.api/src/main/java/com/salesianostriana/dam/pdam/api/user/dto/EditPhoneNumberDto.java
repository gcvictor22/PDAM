package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.pdam.api.validation.annotation.user.OnlyNumber;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniquePhoneNumber;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotEmpty;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EditPhoneNumberDto {

    @NotEmpty(message = "{newUserDto.phone.notEmpty}")
    @UniquePhoneNumber(message = "{newUserDto.phone.unique}")
    @OnlyNumber
    private String phoneNumber;

}
