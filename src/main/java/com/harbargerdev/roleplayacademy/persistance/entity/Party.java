package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="party")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Party {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name="id", nullable = false, updatable = false)
    private String id;
    @Column(name="name", nullable = false)
    private String partyName;
    @Column(name="slug", nullable = true)
    private String slug;
    @Column(name="visbility_cd", nullable = false)
    private String visibilityCode;
    @Column(name="created_by", nullable = false, updatable = false)
    private String createdBy;
    @Column(name="created_at", nullable = false, updatable = false)
    private java.util.Date createdAt;
    @Column(name="deleted_at", nullable = true)
    private java.util.Date deletedAt;

    @OneToMany
    @JoinColumn(name="visibility_cd", nullable = false, insertable = false, updatable = false)
    private PartyVisibility partyVisibility;

    @ManyToOne
    @JoinColumn(name="created_by", nullable = false, updatable = false, insertable = false)
    private Profile creatorProfile;
}
