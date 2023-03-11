package com.salesianostriana.dam.pdam.api.comment.controller;

import com.salesianostriana.dam.pdam.api.comment.dto.NewCommentDto;
import com.salesianostriana.dam.pdam.api.comment.model.Comment;
import com.salesianostriana.dam.pdam.api.comment.service.CommentService;
import com.salesianostriana.dam.pdam.api.post.dto.ViewPostDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;

@RestController
@RequestMapping("/comment")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/{id}")
    public ResponseEntity<ViewPostDto> create(@Valid @RequestBody NewCommentDto newCommentDto, @PathVariable Long id, @AuthenticationPrincipal User user){
        Comment created = commentService.save(newCommentDto);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.getId()).toUri();

        return ResponseEntity.created(createdURI).body(commentService.responseComment(created, id, user));
    }

    @PutMapping("/{id}")
    public ViewPostDto edit(@Valid @RequestBody NewCommentDto newCommentDto, @PathVariable Long id, @AuthenticationPrincipal User user){

        Post post = commentService.edit(newCommentDto, id, user);

        return ViewPostDto.of(post);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id, @AuthenticationPrincipal User user){
        commentService.delete(id, user);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}
