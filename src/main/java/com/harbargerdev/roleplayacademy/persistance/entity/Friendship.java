package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.UUID;

@Entity
@Table(name="friendship")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Friendship {
    @Column(name="user_id", nullable = false, updatable = false)
    private UUID userId;
    @Column(name="friend_id", nullable = false, updatable = false)
    private UUID friendId;
    @Column(name="fr_status_cd", nullable = false)
    private String friendStatusCode;
    @Column(name="created_at", nullable = false, updatable = false)
    private Date createdAt;
    @Column(name="updated_at", nullable = false)
    private Date updatedAt;

    @OneToMany
    @JoinColumn(name="user_id", nullable = false, updatable = false)
    private Profile userProfile;

    @OneToMany
    @JoinColumn(name="fiend_id", nullable = false, updatable = false)
    private Profile friendProfile;

    @OneToMany
    @JoinColumn(name="fr_status_cd", nullable = false)
    private FriendshipStatus friendshipStatus;
}
