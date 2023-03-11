package com.salesianostriana.dam.pdam.api.comment.model;

import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.List;

@Entity
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Comment implements Serializable {

    @Id
    @GeneratedValue
    private Long id;

    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userWhoPost", foreignKey = @ForeignKey(name = "FK_COMMENT_USER"))
    private User userWhoComment;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "commentedPost", foreignKey = @ForeignKey(name = "FK_COMMENT_POST"))
    private Post commentedPost;

    private String imgPath;

    private LocalDate publishedDate;

    /******************************/
    /*           HELPERS           /
    /******************************/

    public void addPost(Post p){
        this.commentedPost = p;
        List<Comment> aux = p.getComments();
        aux.add(this);
        p.setComments(aux);
    }

    @PreRemove
    public void removePost(){
        if (this.userWhoComment != null)
            this.userWhoComment = null;
        if (this.commentedPost != null)
            this.commentedPost.getComments().remove(this);
    }

    public void addUser(User u){
        this.userWhoComment = u;
    }


}
