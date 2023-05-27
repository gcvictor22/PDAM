package com.salesianostriana.dam.pdam.api.payment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetPaymentMethodsListDto {

    private List<GetPaymentMethodDto> content;

    public static GetPaymentMethodsListDto of(List<GetPaymentMethodDto> paymentMethodDtoList) {
        return GetPaymentMethodsListDto.builder()
                .content(paymentMethodDtoList)
                .build();
    }

}
