package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.io.Serializable;

import java.util.UUID;
import java.util.Date;
import java.util.List;

@Entity
@Table(name="profile")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Profile implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name="id", nullable = false, updatable = false)
    private UUID id;

    @Column(name="handle", nullable = false, unique = true)
    private String handle;

    @Column(name="display_name", nullable = false)
    private String displayName;

    @Column(name="avatar_url", nullable = true)
    private String avatarUrl;

    @Column(name="auth_provider", nullable = false)
    private String authProvider;

    @Column(name="auth_subject", nullable = false)
    private String authSubject;

    @Column(name="created_at", nullable = false, updatable = false)
    private Date createdAt;

    @Column(name="deleted_at" nullable = true)
    private Date deletedAt;

    @Transient
    private List<Friendship> friends;
}
