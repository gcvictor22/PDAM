package com.salesianostriana.dam.pdam.api.post.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.user.dto.UserWhoLikeDto;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetPostDto {

    private Long id;
    private String affair;
    private String content;
    private List<String> imgPath;
    private UserWhoLikeDto userWhoPost;
    private int usersWhoLiked;
    private int comments;
    private boolean likedByUser;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime postDate;

    public static GetPostDto of(Post post, User user){
        return GetPostDto.builder()
                .id(post.getId())
                .affair(post.getAffair())
                .content(post.getContent())
                .imgPath(post.getImgPaths())
                .userWhoPost(UserWhoLikeDto.of(post.getUserWhoPost(), user))
                .usersWhoLiked(post.getUsersWhoLiked() == null ? 0 : post.getUsersWhoLiked().size())
                .comments(post.getComments() == null ? 0 : post.getComments().size())
                .postDate(post.getPostDate())
                .likedByUser(user.getLikedPosts().stream().filter(p -> Objects.equals(p.getId(), post.getId())).toList().size() > 0)
                .build();
    }

}
