package com.salesianostriana.dam.pdam.api.payment.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.payment.model.CardType;
import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.YearMonth;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetPaymentMethodDto {

    private Long id;
    private String number;
    private String holder;
    private String expiredDate;
    private boolean active;
    private CardType type;

    public static GetPaymentMethodDto of(PaymentMethod paymentMethod){
        return GetPaymentMethodDto.builder()
                .id(paymentMethod.getId())
                .number(paymentMethod.getNumber())
                .holder(paymentMethod.getHolder())
                .expiredDate(paymentMethod.getExpiredDate())
                .active(paymentMethod.isActiveMethod())
                .type(paymentMethod.getType())
                .build();
    }

}

