package com.salesianostriana.dam.pdam.api.post.controller;

import com.salesianostriana.dam.pdam.api.exception.notfound.PostNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.post.dto.GetPostDto;
import com.salesianostriana.dam.pdam.api.post.dto.NewPostDto;
import com.salesianostriana.dam.pdam.api.post.dto.ViewPostDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.post.service.PostService;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/post")
@RequiredArgsConstructor
public class PostController {

    private final PostService postService;

    @GetMapping("/")
    public GetPageDto<GetPostDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable, @AuthenticationPrincipal User user){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return postService.findAll(params, pageable, user.getId());
    }

    @GetMapping("/{id}")
    public ViewPostDto viewPost(@PathVariable Long id){
        Post post = postService.findById(id);
        return ViewPostDto.of(post);
    }

    @PostMapping("/")
    public ResponseEntity<GetPostDto> create(@AuthenticationPrincipal User user,@Valid @RequestBody NewPostDto newPostDto){
        Post created = postService.save(newPostDto, user);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.getId()).toUri();

        return ResponseEntity.created(createdURI).body(postService.responseCreate(created, user.getId()));
    }

    @PutMapping("/{id}")
    @PreAuthorize("@postService.findById(#id).userWhoPost.id == authentication.principal.id")
    public ViewPostDto editPost(@PathVariable Long id, @RequestBody NewPostDto newPostDto){
        Post postEdited = postService.edit(id, newPostDto);

        return ViewPostDto.of(postEdited);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("@postService.findById(#id).userWhoPost.id == authentication.principal.id")
    public ResponseEntity<?> deletePost(@PathVariable Long id) {
        postService.deleteById(id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @PostMapping("/like/{id}")
    public ResponseEntity<GetPostDto> like(@PathVariable Long id, @AuthenticationPrincipal User user){

        GetPostDto post = postService.likeAPost(id, user);

        return ResponseEntity.status(HttpStatus.CREATED).body(post);
    }

}
