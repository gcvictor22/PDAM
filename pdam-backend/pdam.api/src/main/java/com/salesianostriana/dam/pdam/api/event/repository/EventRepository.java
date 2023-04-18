package com.salesianostriana.dam.pdam.api.event.repository;

import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.user.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;
import java.util.UUID;

public interface    EventRepository extends JpaRepository<Event, Long> {

    @Query("""
            SELECT ROUND((COUNT(DISTINCT u) * 100.0) /
                (SELECT COUNT(DISTINCT u2)
                FROM User u2
                WHERE u2.city.id = :cityId
                AND SIZE(u2.events) > 0)
            , 0)
            FROM User u
            JOIN u.events e
            WHERE u.city.id = :cityId
            AND e.id = :eventId
                """)
    int popularityCityEvent(Long cityId, Long eventId);


    @Query("""
            SELECT e
            FROM Event e
            ORDER BY e.popularity DESC
            """)
    Page<Event> findAll(Specification<Post> spec, Pageable pageable);

    @Query("""
            SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END
            FROM Event e
            JOIN e.authUsers u
            WHERE u = :user AND e = :event
            """)
    boolean userAuth(User user, Event event);
}
