package com.salesianostriana.dam.pdam.api.event.controller;

import com.salesianostriana.dam.pdam.api.event.dto.GetEventAllDto;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.event.service.EventService;
import com.salesianostriana.dam.pdam.api.files.service.StorageService;
import com.salesianostriana.dam.pdam.api.files.utils.MediaTypeUrlResource;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import lombok.AllArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/event")
@AllArgsConstructor
public class EventController {

    private final EventService eventService;
    private final StorageService storageService;

    @GetMapping("/")
    public GetPageDto<GetEventAllDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable
    ){
        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return eventService.findAll(params, pageable);
    }

    @GetMapping("/{id}/img")
    public ResponseEntity<Resource> getEventImg(@PathVariable Long id){
        Event event = eventService.findById(id);

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(event.getImgPath());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @PutMapping("/{id}/addAuthUsers")
    public GetEventAllDto addAuthUsers(@RequestBody List<String> newAuthUsersDto, @PathVariable Long id){
        return eventService.addAuthUsers(id, newAuthUsersDto);
    }

}
