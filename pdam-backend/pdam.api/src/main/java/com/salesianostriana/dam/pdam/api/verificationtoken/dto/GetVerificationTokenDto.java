package com.salesianostriana.dam.pdam.api.verificationtoken.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetVerificationTokenDto {

    private String email;
    private int verificationNumber;

}
