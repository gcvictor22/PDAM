package com.salesianostriana.dam.pdam.api.post.repository;

import com.salesianostriana.dam.pdam.api.post.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;

import java.util.List;
import java.util.UUID;

public interface PostRepository extends JpaRepository<Post, Long>, JpaSpecificationExecutor<Post> {

    @Query("""
            select distinct p from Post p
            left join fetch p.comments
            """)
    List<Post> postComments();

    @Query("""
            SELECT CASE WHEN COUNT(p) > 0 THEN false ELSE true END
            FROM Post p
            WHERE p.id = :postId
            AND NOT EXISTS (SELECT ul FROM p.usersWhoLiked ul WHERE ul.id = :userId)
            """)
    boolean existsLikeByUser(@Param("postId") Long postId, @Param("userId") UUID userId);

    @Query("""
            SELECT p
            FROM Post p
            ORDER BY p.postDate DESC
            """)
    Page<Post> findAll(@Nullable Specification<Post> spec, Pageable pageable);

    @Query("""
            SELECT p
            FROM Post p
            WHERE p.userWhoPost.id IN (
                SELECT f.id
                FROM User u
                JOIN u.follows f
                WHERE u.id = :userId
            ) OR p.userWhoPost.id = :userId
            ORDER BY p.postDate DESC
            """)
    Page<Post> findAllFollowsPosts(UUID userId, Pageable pageable);

    @Query("""
            SELECT p
            FROM Post p
            WHERE p.userWhoPost.id IN (
                SELECT f.id
                FROM User u
                JOIN u.follows f
                WHERE u.id = :userId
            ) OR p.userWhoPost.id = :userId
            ORDER BY p.postDate DESC
            """)
    List<Post> findAllFollowsPosts(UUID userId);
}
