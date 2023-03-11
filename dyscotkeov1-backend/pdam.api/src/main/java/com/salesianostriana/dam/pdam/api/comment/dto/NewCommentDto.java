package com.salesianostriana.dam.pdam.api.comment.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.URL;

import javax.validation.constraints.NotEmpty;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NewCommentDto {

    @Length(max = 250, message = "{newCommentDto.content.max}")
    @NotEmpty(message = "{newCommentDto.content.notEmpty}")
    private String content;

    @URL(message = "{newUserDto.imgPath.url}")
    private String imgPath;
}
