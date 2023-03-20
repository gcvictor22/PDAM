package com.salesianostriana.dam.pdam.api.comment.dto;

import com.salesianostriana.dam.pdam.api.comment.model.Comment;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetCommentDto {

    private Long id;
    private String userName;
    private String content;
    private String imgPath;

    public static GetCommentDto of(Comment comment){
        return GetCommentDto.builder()
                .id(comment.getId())
                .userName(comment.getUserWhoComment().getUsername())
                .content(comment.getContent())
                .imgPath(comment.getImgPath())
                .build();
    }

}
