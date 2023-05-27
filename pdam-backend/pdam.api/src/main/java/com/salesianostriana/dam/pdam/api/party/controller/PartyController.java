package com.salesianostriana.dam.pdam.api.party.controller;

import com.salesianostriana.dam.pdam.api.event.service.EventService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyDto;
import com.salesianostriana.dam.pdam.api.party.dto.NewPartyDto;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.party.service.PartyService;
import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import com.salesianostriana.dam.pdam.api.payment.service.PaymentMethodService;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.Charge;
import com.stripe.model.PaymentIntent;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.method.P;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.persistence.EntityNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/party")
@AllArgsConstructor
public class PartyController {

    private final PartyService partyService;
    private final UserService userService;
    private final EventService eventService;

    @GetMapping("/{id}")
    public GetPageDto<GetPartyDto> findAll(@PathVariable Long id,
            @PageableDefault(size = 20, page = 0) Pageable pageable){

        return partyService.findAll(pageable, id);

    }

    @PostMapping("/")
    @PreAuthorize("@eventService.authUser(#loggedUser)")
    public ResponseEntity<GetPartyDto> create(@RequestBody NewPartyDto newPartyDto, @AuthenticationPrincipal User loggedUser){
        User user = userService.getProfile(loggedUser.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(partyService.save(newPartyDto, user));
    }

    @PostMapping("/buy/{id}")
    public ResponseEntity<?> buy(@PathVariable Long id, @AuthenticationPrincipal User loggedUser) throws MessagingException, IOException {
        User user = userService.getProfile(loggedUser.getId());
        Party party = partyService.buy(id, user);
        if (!user.getPaymentMethods().isEmpty() || party.getDiscotheque().getCapacity() < party.getClients().size()) {
            PaymentIntent paymentIntent = partyService.createStripe(party, user);
            partyService.setUpdatedPopularity(party.getDiscotheque());

            return ResponseEntity.status(HttpStatus.CREATED).body(GetPartyDto.ofStripe(party, paymentIntent.getId()));
        }else {
            if (user.getPaymentMethods().isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new EntityNotFoundException("No tienes ningún método de pago"));
            }else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new EntityNotFoundException("No quedan entradas disponibles para esta fiesta"));
            }
        }
    }

    @PostMapping("/confirm/{id}")
    public ResponseEntity<?> confirmBuy(@PathVariable String id, @AuthenticationPrincipal User loggedUser) throws MessagingException, IOException {
        User user = userService.getProfile(loggedUser.getId());

        partyService.confirmStripe(id, user);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @PostMapping("/cancel/{id}")
    public ResponseEntity<?> cancelBuy(@PathVariable String id) {
        partyService.cancelStripe(id);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

}
