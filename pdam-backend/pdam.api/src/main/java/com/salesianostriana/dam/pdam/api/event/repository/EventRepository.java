package com.salesianostriana.dam.pdam.api.event.repository;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface EventRepository extends JpaRepository<Event, Long> {
/*
    @Query("""
            SELECT COALESCE(
              CAST(COUNT(DISTINCT eu.user_id) * 100.0 / NULLIF(
                (SELECT COUNT(DISTINCT u.id)
                 FROM user_entity u
                 JOIN attendedevents ae ON u.id = ae.user_id
                 JOIN event e ON ae.event_id = e.id
                 WHERE e.city  = :cityId
                 AND e.id = :eventId), 0
              ) AS INT), 0
            ) AS percentage
            FROM attendedevents eu
            JOIN event e ON e.id = eu.event_id
            WHERE e.city = :cityId
            """)
 */
    @Query("""
            SELECT ROUND((COUNT(DISTINCT u) * 100.0) / (SELECT COUNT(DISTINCT u2) FROM User u2 WHERE u2.city.id = :cityId), 0)
            FROM User u JOIN u.events e
            WHERE u.city.id = :cityId AND e.id = :eventId
                        """)
    int popularityCityEvent(Long cityId, Long eventId);

}
