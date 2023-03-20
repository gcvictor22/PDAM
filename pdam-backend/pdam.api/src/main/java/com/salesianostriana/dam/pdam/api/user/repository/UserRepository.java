package com.salesianostriana.dam.pdam.api.user.repository;

import com.salesianostriana.dam.pdam.api.user.model.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID>, JpaSpecificationExecutor<User> {

    boolean existsByUserName(String s);

    boolean existsByEmail(String e);

    boolean existsByPhoneNumber(String p);

    @Query("""
            select u from User u
            left join fetch u.publishedPosts
            where u.id = :id
            """)
    Optional<User> userWithPostsById (UUID id);

    @Query("""
            select u from User u
            left join fetch u.publishedPosts
            where u.userName = :userName
            """)
    Optional<User> userWithPostsByUserName (String userName);


    @Query("""
            SELECT CASE WHEN COUNT(f) > 0 THEN true ELSE false END
            FROM User u
            JOIN u.followers f
            WHERE u.id = :id1
            AND f.id = :id2
            """)
    boolean checkFollow(@Param("id1") UUID id1, @Param("id2") UUID id2);

    @Query("""
            SELECT CASE WHEN COUNT(u) > 0 THEN false ELSE true END
            FROM User u
            WHERE u.id = :id1
            AND NOT EXISTS (SELECT lu FROM u.follows lu WHERE lu.id = :id2)
            """)
    boolean checkFollower(@Param("id1") UUID id1, @Param("id2") UUID id2);
}
