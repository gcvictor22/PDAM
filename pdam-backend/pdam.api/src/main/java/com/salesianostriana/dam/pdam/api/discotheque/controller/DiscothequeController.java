package com.salesianostriana.dam.pdam.api.discotheque.controller;

import com.salesianostriana.dam.pdam.api.discotheque.dto.GetDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.dto.NewAuthUsersDto;
import com.salesianostriana.dam.pdam.api.discotheque.dto.NewDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.discotheque.service.DiscothequeService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/discotheque")
@AllArgsConstructor
public class DiscothequeController {

    private final DiscothequeService discothequeService;


    @GetMapping("/")
    public GetPageDto<GetDiscothequeDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable, @AuthenticationPrincipal User loggedUser){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return discothequeService.findAll(params, pageable, loggedUser);
    }

    @PostMapping("/")
    public ResponseEntity<GetDiscothequeDto> create(@RequestBody NewDiscothequeDto newDiscothequeDto){
        return ResponseEntity.status(HttpStatus.CREATED).body(discothequeService.save(newDiscothequeDto));
    }

    @PutMapping("/addAuthUsers")
    public GetDiscothequeDto addAuthUsers(@RequestBody NewAuthUsersDto newAuthUsersDto){
        return discothequeService.addAuthUsers(newAuthUsersDto);
    }

}
