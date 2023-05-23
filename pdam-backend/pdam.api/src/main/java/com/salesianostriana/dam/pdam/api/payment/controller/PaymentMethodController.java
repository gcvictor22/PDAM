package com.salesianostriana.dam.pdam.api.payment.controller;

import com.salesianostriana.dam.pdam.api.payment.dto.GetPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.dto.NewPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import com.salesianostriana.dam.pdam.api.payment.service.PaymentMethodService;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RequestMapping("/payment")
@RestController
@RequiredArgsConstructor
public class PaymentMethodController {

    private final PaymentMethodService paymentMethodService;


    @GetMapping("/")
    public List<GetPaymentMethodDto> findAll(@AuthenticationPrincipal User loggedUser){
        return paymentMethodService.findAll(loggedUser);
    }

    @PostMapping("/")
    public ResponseEntity<GetPaymentMethodDto> create(@RequestBody NewPaymentMethodDto newPaymentMethodDto, @AuthenticationPrincipal User user) {
        PaymentMethod paymentMethod = paymentMethodService.create(newPaymentMethodDto, user);
        paymentMethod.setNumber("**** **** **** "+newPaymentMethodDto.getNumber().substring(12, 16));

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(paymentMethod.getId()).toUri();
        return  ResponseEntity.status(HttpStatus.CREATED).body(GetPaymentMethodDto.of(paymentMethod));
    }

}
