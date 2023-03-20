package com.salesianostriana.dam.pdam.api.page.dto;

import lombok.*;
import org.springframework.data.domain.Page;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class GetPageDto<T> {

    private List<T> content;
    private int currentPage;
    private boolean last;
    private boolean first;
    private int totalPages;
    private Long totalElements;

    public GetPageDto(Page<T> page){
        this.content = page.getContent();
        this.currentPage = page.getNumber();
        this.last = page.isLast();
        this.first = page.isFirst();
        this.totalPages = page.getTotalPages()-1;
        this.totalElements = page.getTotalElements();
    }

}
