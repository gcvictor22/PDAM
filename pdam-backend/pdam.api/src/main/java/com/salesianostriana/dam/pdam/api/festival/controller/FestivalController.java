package com.salesianostriana.dam.pdam.api.festival.controller;

import com.salesianostriana.dam.pdam.api.festival.dto.GetFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.dto.NewFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.service.FestivalService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/festival")
@RequiredArgsConstructor
public class FestivalController {

    private final FestivalService festivalService;

    @PostMapping("/")
    public ResponseEntity<GetFestivalDto> create(@RequestBody NewFestivalDto newFestivalDto){
        return ResponseEntity.status(HttpStatus.CREATED).body(festivalService.save(newFestivalDto));
    }
}
