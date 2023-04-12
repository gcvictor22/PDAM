package com.salesianostriana.dam.pdam.api.event.controller;

import com.salesianostriana.dam.pdam.api.discotheque.dto.GetDiscothequeDto;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventDto;
import com.salesianostriana.dam.pdam.api.event.service.EventService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/event")
@AllArgsConstructor
public class EventController {

    private final EventService eventService;

    @GetMapping("/")
    public GetPageDto<GetEventDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable
    ){
        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return eventService.findAll(params, pageable);
    }

    @PutMapping("/{id}/addAuthUsers")
    public GetEventDto addAuthUsers(@RequestBody List<String> newAuthUsersDto, @PathVariable Long id){
        return eventService.addAuthUsers(id, newAuthUsersDto);
    }

}
