package com.salesianostriana.dam.pdam.api.post.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.comment.dto.GetCommentDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.user.dto.UserWhoLikeDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ViewPostDto {

    private Long id;
    private String affair;
    private String content;
    private List<String> imgPath;
    private String userWhoPost;
    private List<UserWhoLikeDto> usersWhoLiked;
    private List<GetCommentDto> comments;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime postDate;

    public static ViewPostDto of(Post post){
        return ViewPostDto.builder()
                .id(post.getId())
                .affair(post.getAffair())
                .content(post.getContent())
                .imgPath(post.getImgPaths())
                .userWhoPost(post.getUserWhoPost().getUsername())
                .usersWhoLiked(post.getUsersWhoLiked().stream().map(UserWhoLikeDto::of).toList())
                .comments(post.getComments().stream().map(GetCommentDto::of).toList())
                .postDate(post.getPostDate())
                .build();
    }

}
