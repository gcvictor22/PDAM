package com.salesianostriana.dam.pdam.api.party.controller;

import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.party.dto.GetNewPartyDto;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyDto;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyListDto;
import com.salesianostriana.dam.pdam.api.party.dto.NewPartyDto;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.party.service.PartyService;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/party")
@AllArgsConstructor
public class PartyController {

    private final PartyService partyService;
    private final UserService userService;

    @GetMapping("/")
    public GetPageDto<GetPartyListDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return partyService.findAll(params, pageable);

    }

    @PostMapping("/create")
    public ResponseEntity<GetNewPartyDto> create(@RequestBody NewPartyDto newPartyDto){
        return ResponseEntity.status(HttpStatus.CREATED).body(partyService.save(newPartyDto));
    }

    @PostMapping("/buy/{id}")
    public ResponseEntity<GetNewPartyDto> buy(@PathVariable Long id, @AuthenticationPrincipal User loggedUser){

        User user = userService.getProfile(loggedUser.getId());
        Party party = partyService.buy(id, user);
        partyService.setUpdatedPopularity(party.getDiscotheque());

        return ResponseEntity.status(HttpStatus.CREATED).body(GetNewPartyDto.of(party));
    }

}
