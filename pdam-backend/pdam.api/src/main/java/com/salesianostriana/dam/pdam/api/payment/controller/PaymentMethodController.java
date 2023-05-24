package com.salesianostriana.dam.pdam.api.payment.controller;

import com.salesianostriana.dam.pdam.api.payment.dto.GetPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.dto.GetPaymentMethodsListDto;
import com.salesianostriana.dam.pdam.api.payment.dto.NewPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.model.CardType;
import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import com.salesianostriana.dam.pdam.api.payment.service.PaymentMethodService;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@RequestMapping("/payment")
@RestController
@RequiredArgsConstructor
public class PaymentMethodController {

    private final PaymentMethodService paymentMethodService;


    @GetMapping("/")
    public GetPaymentMethodsListDto findAll(@AuthenticationPrincipal User loggedUser){
        return GetPaymentMethodsListDto.of(paymentMethodService.findAll(loggedUser));
    }

    @PostMapping("/")
    public ResponseEntity<GetPaymentMethodDto> create(@Valid @RequestBody NewPaymentMethodDto newPaymentMethodDto, @AuthenticationPrincipal User user) {
        PaymentMethod paymentMethod = paymentMethodService.create(newPaymentMethodDto, user);
        if (paymentMethod.getType().equals(CardType.AMERICAN_EXPRESS) || paymentMethod.getNumber().length() == 15){
            paymentMethod.setNumber("**** ****** *"+newPaymentMethodDto.getNumber().substring(11, 15));
        }else {
            paymentMethod.setNumber("**** **** **** "+newPaymentMethodDto.getNumber().substring(12, 16));
        }

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(paymentMethod.getId()).toUri();
        return  ResponseEntity.status(HttpStatus.CREATED).body(GetPaymentMethodDto.of(paymentMethod));
    }

    @PutMapping("/activate/{id}")
    public GetPaymentMethodDto updateActiveMethod(@PathVariable Long id, @AuthenticationPrincipal User loggedUser) {
        return GetPaymentMethodDto.of(paymentMethodService.activateMethod(loggedUser, id));
    }

}
