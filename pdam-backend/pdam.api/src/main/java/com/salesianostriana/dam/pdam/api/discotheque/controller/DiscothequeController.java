package com.salesianostriana.dam.pdam.api.discotheque.controller;

import com.salesianostriana.dam.pdam.api.discotheque.dto.NewDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.service.DiscothequeService;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventDto;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/discotheque")
@AllArgsConstructor
public class DiscothequeController {

    private final DiscothequeService discothequeService;
    private final UserService userService;


    @GetMapping("/")
    public GetPageDto<GetEventDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return discothequeService.findAll(params, pageable);
    }

    @PostMapping("/")
    @PreAuthorize("@userService.isAdmin(#loggedUser)")
    public ResponseEntity<GetEventDto> create(@RequestBody NewDiscothequeDto newDiscothequeDto, @AuthenticationPrincipal User loggedUser){
        return ResponseEntity.status(HttpStatus.CREATED).body(discothequeService.save(newDiscothequeDto));
    }

}
