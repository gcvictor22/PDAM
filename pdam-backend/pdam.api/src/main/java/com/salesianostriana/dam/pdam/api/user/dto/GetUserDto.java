package com.salesianostriana.dam.pdam.api.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Data
@SuperBuilder
public class GetUserDto {

    protected UUID id;
    protected String userName;
    protected String fullName;
    protected String imgPath;
    protected int followers;
    protected int countOfPosts;
    protected boolean verified;
    protected boolean followedByUser;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    protected LocalDateTime createdAt;

    public static GetUserDto of(User c){
        return GetUserDto.builder()
                .id(c.getId())
                .userName(c.getUsername())
                .fullName(c.getFullName())
                .imgPath(c.getImgPath())
                .followers(c.getFollowers() == null ? 0 : c.getFollowers().size())
                .countOfPosts(c.getPublishedPosts() == null ? 0 : c.getPublishedPosts().size())
                .verified(c.isVerified())
                .createdAt(c.getCreatedAt())
                .build();
    }

    public static GetUserDto ofs(User c, User loggedUser){
        return GetUserDto.builder()
                .id(c.getId())
                .userName(c.getUsername())
                .fullName(c.getFullName())
                .imgPath(c.getImgPath())
                .followers(c.getFollowers() == null ? 0 : c.getFollowers().size())
                .countOfPosts(c.getPublishedPosts() == null ? 0 : c.getPublishedPosts().size())
                .verified(c.isVerified())
                .followedByUser(c.getFollowers().stream().filter(u -> Objects.equals(u.getId(), loggedUser.getId())).toList().size() > 0)
                .createdAt(c.getCreatedAt())
                .build();
    }

}
