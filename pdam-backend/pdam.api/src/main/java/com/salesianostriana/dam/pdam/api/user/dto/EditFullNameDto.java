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
public class EditFullNameDto {

    @NotEmpty(message = "{newUserDto.fullname.notempty}")
    private String fullName;

}
