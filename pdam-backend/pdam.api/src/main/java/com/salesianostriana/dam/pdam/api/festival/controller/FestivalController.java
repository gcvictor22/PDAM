package com.salesianostriana.dam.pdam.api.festival.controller;

import com.google.zxing.WriterException;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventDto;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.event.service.EventService;
import com.salesianostriana.dam.pdam.api.festival.dto.GetFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.dto.NewFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import com.salesianostriana.dam.pdam.api.festival.service.FestivalService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.stripe.model.PaymentIntent;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.persistence.EntityNotFoundException;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/festival")
@RequiredArgsConstructor
public class FestivalController {

    private final FestivalService festivalService;
    private final EventService eventService;
    private final UserService userService;

    @GetMapping("/")
    public GetPageDto<GetEventDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable) {

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return festivalService.findAll(params, pageable);
    }

    @GetMapping("/{id}")
    public GetFestivalDto findOne(@PathVariable Long id) {
        return GetFestivalDto.of(festivalService.findById(id));
    }

    @PostMapping("/")
    public ResponseEntity<GetEventDto> create(@RequestBody NewFestivalDto newFestivalDto){
        return ResponseEntity.status(HttpStatus.CREATED).body(festivalService.save(newFestivalDto));
    }

    @PostMapping("/buy/{id}")
    public ResponseEntity<?> buyFestival(@PathVariable Long id, @AuthenticationPrincipal User loggedUser) {
        User user = userService.getProfile(loggedUser.getId());
        Festival festival = festivalService.buy(id, user);

        if (!user.getPaymentMethods().isEmpty() || festival.getCapacity() < festival.getClients().size()) {
            PaymentIntent paymentIntent = festivalService.createStripe(festival, user);
            return ResponseEntity.status(HttpStatus.CREATED).body(GetFestivalDto.ofStripe(festival, paymentIntent.getId()));
        }else {
            if (user.getPaymentMethods().isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new EntityNotFoundException("No tienes ningún método de pago"));
            }else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new EntityNotFoundException("No quedan entradas disponibles para este festival"));
            }
        }
    }

    @PostMapping("/confirm/{id}")
    public ResponseEntity<?> confirmBuy(@PathVariable String id, @AuthenticationPrincipal User loggedUser) throws MessagingException, IOException, WriterException {
        User user = userService.getProfile(loggedUser.getId());

        festivalService.confirmStripe(id, user);
        return ResponseEntity.status(HttpStatus.OK).build();
    }

    @PostMapping("/cancel/{id}")
    public ResponseEntity<?> cancelBuy(@PathVariable String id) {
        festivalService.cancelStripe(id);
        return ResponseEntity.status(HttpStatus.OK).build();
    }
}
