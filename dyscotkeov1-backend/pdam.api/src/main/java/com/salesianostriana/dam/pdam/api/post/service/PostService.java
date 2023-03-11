package com.salesianostriana.dam.pdam.api.post.service;

import com.salesianostriana.dam.pdam.api.exception.accesdenied.PostAccessDeniedExeption;
import com.salesianostriana.dam.pdam.api.exception.badrequest.PostBadRequestToDeleteException;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyPostListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.PostNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.post.dto.GetPostDto;
import com.salesianostriana.dam.pdam.api.post.dto.NewPostDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.post.repository.PostRepository;
import com.salesianostriana.dam.pdam.api.search.specifications.post.PSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final UserRepository userRepository;

    public GetPageDto<GetPostDto> findAll(List<SearchCriteria> params, Pageable pageable, User user) {
        if (postRepository.findAll().isEmpty())
            throw new EmptyPostListException();

        PSBuilder psBuilder = new PSBuilder(params);

        Specification<Post> spec = psBuilder.build();
        Page<GetPostDto> pageGetClientDto = postRepository.findAll(spec, pageable).map(p -> GetPostDto.of(p, user));

        return new GetPageDto<>(pageGetClientDto);
    }

    public Post save(NewPostDto newPostDto, User user){
        Post newPost = Post.builder()
                .affair(newPostDto.getAffair())
                .content(newPostDto.getContent())
                .postDate(LocalDateTime.now())
                .build();

        return postRepository.save(newPost);
    }

    public GetPostDto responseCreate(Post newPost, User user){
        newPost.addUser(user);
        userRepository.save(user);
        return GetPostDto.of(newPost, user);
    }

    public Post findById(Long id) {
        return postRepository.findById(id).orElseThrow(() -> new PostNotFoundException(id));
    }

    public Post edit(Long id, NewPostDto newPostDto, User loggedUser) {

        Post post = postRepository.findById(id).orElseThrow(() -> new PostNotFoundException(id));

        if (!Objects.equals(loggedUser.getUsername(), post.getUserWhoPost().getUsername())){
            throw new PostAccessDeniedExeption();
        }
        return postRepository.findById(id)
                .map(old -> {
                    old.setAffair(newPostDto.getAffair());
                    old.setContent(newPostDto.getContent());
                    return postRepository.save(old);
                }).orElseThrow(() -> new PostNotFoundException(id));
    }

    public void deleteById(Long id, User loggedUser) {
        Post post = postRepository.findById(id).orElseThrow(() -> new PostBadRequestToDeleteException(id));

        if (!Objects.equals(loggedUser.getUsername(), post.getUserWhoPost().getUsername())){
            throw new PostAccessDeniedExeption();
        }

        postRepository.delete(post);
    }

    public GetPostDto likeAPost(Long id, User loggedUser) {

        Post post = postRepository.findById(id).orElseThrow(() -> new PostNotFoundException(id));
        boolean b = postRepository.existsLikeByUser(post.getId(), loggedUser.getId());

        post.like(loggedUser, b);

        postRepository.save(post);
        userRepository.save(loggedUser);

        GetPostDto dto = GetPostDto.of(post, loggedUser);
        if (Objects.equals(dto.getUserWhoPost().getUserName(), loggedUser.getUsername())){
            if (b){
                dto.setUsersWhoLiked(dto.getUsersWhoLiked()-1);
            }else {
                dto.setUsersWhoLiked(dto.getUsersWhoLiked()+1);
            }
        }

        return dto;
    }
}
