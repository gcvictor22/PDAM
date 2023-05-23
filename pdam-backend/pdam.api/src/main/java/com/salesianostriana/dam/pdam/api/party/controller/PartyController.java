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
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
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

    @GetMapping("/")
    public GetPageDto<GetPartyDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return partyService.findAll(params, pageable);

    }

    @PostMapping("/")
    @PreAuthorize("@eventService.authUser(#user)")
    public ResponseEntity<GetPartyDto> create(@RequestBody NewPartyDto newPartyDto, @AuthenticationPrincipal User user){
        return ResponseEntity.status(HttpStatus.CREATED).body(partyService.save(newPartyDto, user));
    }

    @PostMapping("/buy/{id}")
    public ResponseEntity<?> buy(@PathVariable Long id, @AuthenticationPrincipal User loggedUser) throws MessagingException, IOException {

        User user = userService.getProfile(loggedUser.getId());
        Party party = partyService.buy(id, user);
        partyService.setUpdatedPopularity(party.getDiscotheque());

        return ResponseEntity.status(HttpStatus.CREATED).body(GetPartyDto.of(party));
    }

}
