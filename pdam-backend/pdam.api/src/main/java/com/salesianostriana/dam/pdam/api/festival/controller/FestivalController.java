package com.salesianostriana.dam.pdam.api.festival.controller;

import com.salesianostriana.dam.pdam.api.festival.dto.GetFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.dto.NewFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.service.FestivalService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/festival")
@RequiredArgsConstructor
public class FestivalController {

    private final FestivalService festivalService;

    @GetMapping("/")
    public GetPageDto<GetFestivalDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable) {

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return festivalService.findAll(params, pageable);
    }

    @PostMapping("/")
    public ResponseEntity<GetFestivalDto> create(@RequestBody NewFestivalDto newFestivalDto){
        return ResponseEntity.status(HttpStatus.CREATED).body(festivalService.save(newFestivalDto));
    }
}
