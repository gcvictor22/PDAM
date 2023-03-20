package com.salesianostriana.dam.pdam.api.post.dto;

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
public class NewPostDto {

    @Length(max = 25, message = "{newPostDto.affair.max}")
    private String affair;

    @NotEmpty(message = "{newPostDto.content.notEmpty}")
    @Length(max = 250, message = "{newPostDto.content.max}")
    private String content;

}
