package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="party_membership")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PartyMembership {
    @Column(name="group_id", nullable = false, updatable = false)
    private String groupId;
    @Column(name="user_id", nullable = false, updatable = false)
    private String userId;
    @Column(name="role_cd", nullable = false)
    private String roleCode;
    @Column(name="group_mbr_status_cd", nullable = false)
    private String groupMemberStatusCode;
    @Column(name="joined_at", nullable = false, updatable = false)
    private java.util.Date joinedAt;

    @OneToMany
    @JoinColumn(name="role_cd", nullable = false, updatable = false)
    private PartyMemberRole partyMemberRole;

    @OneToMany
    @JoinColumn(name="group_mbr_status_cd", nullable = false, updatable = false)
    private PartyMemberStatus partyMemberStatus;

    @ManyToOne
    @JoinColumn(name="user_id", nullable = false, updatable = false, insertable = false)
    private Profile profile;
}
