package com.salesianostriana.dam.pdam.api.comment.service;

import com.salesianostriana.dam.pdam.api.comment.dto.NewCommentDto;
import com.salesianostriana.dam.pdam.api.comment.model.Comment;
import com.salesianostriana.dam.pdam.api.comment.repository.CommentRespository;
import com.salesianostriana.dam.pdam.api.exception.accesdenied.CommentDeniedAccessException;
import com.salesianostriana.dam.pdam.api.exception.badrequest.CommentBadRequestToDeleteException;
import com.salesianostriana.dam.pdam.api.exception.notfound.CommentNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.PostNotFoundException;
import com.salesianostriana.dam.pdam.api.post.dto.ViewPostDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.post.repository.PostRepository;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRespository commentRespository;
    private final PostRepository postRepository;

    public Comment save(NewCommentDto newCommentDto) {
        Comment comment = Comment.builder()
                .content(newCommentDto.getContent())
                .imgPath(newCommentDto.getImgPath())
                .build();

        return commentRespository.save(comment);
    }

    public ViewPostDto responseComment(Comment comment, Long id, User user){
        Post post = postRepository.findById(id).orElseThrow(() -> new PostNotFoundException(id));

        comment.addPost(post);
        comment.addUser(user);
        postRepository.save(post);
        commentRespository.save(comment);

        return ViewPostDto.of(post);
    }

    public Post edit(NewCommentDto newCommentDto, Long id, User loggedUser) {

        Comment comment = commentRespository.findById(id).orElseThrow(() -> new CommentNotFoundException(id));
        Post post = postRepository.findById(comment.getCommentedPost().getId()).orElseThrow(() -> new PostNotFoundException(comment.getCommentedPost().getId()));

        if (loggedUser.getId() != comment.getUserWhoComment().getId()){
            throw new CommentDeniedAccessException();
        }
        if (!post.getComments().contains(comment)){
            throw new CommentNotFoundException(id);
        }
        commentRespository.findById(id).map(old -> {
            old.setContent(newCommentDto.getContent());
            old.setImgPath(newCommentDto.getImgPath());
            return commentRespository.save(old);
        });
        return post;
    }

    public void delete(Long id, User loggedUser){
        Comment comment = commentRespository.findById(id).orElseThrow(() -> new CommentNotFoundException(id));
        Post post = postRepository.findById(comment.getCommentedPost().getId()).orElseThrow(() -> new PostNotFoundException(comment.getCommentedPost().getId()));

        if (!loggedUser.getUsername().equalsIgnoreCase(comment.getUserWhoComment().getUsername())){
            throw new CommentDeniedAccessException();
        }
        if (!post.getComments().contains(comment)){
            throw new CommentBadRequestToDeleteException(id);
        }
        comment.removePost();
        commentRespository.delete(comment);
    }
}
