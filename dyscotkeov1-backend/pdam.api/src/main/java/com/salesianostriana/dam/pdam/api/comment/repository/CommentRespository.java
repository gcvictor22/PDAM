package com.salesianostriana.dam.pdam.api.comment.repository;

import com.salesianostriana.dam.pdam.api.comment.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRespository extends JpaRepository<Comment, Long> {
}
