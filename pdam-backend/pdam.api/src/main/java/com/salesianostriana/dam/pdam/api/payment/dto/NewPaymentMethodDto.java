package com.salesianostriana.dam.pdam.api.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.OnlyNumber;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.LuhnCheck;
import org.springframework.format.annotation.NumberFormat;

import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NewPaymentMethodDto {

    @LuhnCheck
    @NotNull(message = "El número no puede estar vacío")
    @Length(min = 15, max = 16, message = "El número tiene que ser de 16 dígitos")
    private String number;

    @NotNull(message = "El nombre del titular no puede estar vacío")
    private String holder;

    @NotNull(message = "La fecha y hora no puede estar vacía")
    private String expiredDate;

    @Length(min = 3, max = 4, message = "El código de seguridad tiene que ser de 3 dígitos")
    private String cvv;

}
