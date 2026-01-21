package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="party_member_role")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PartyMemberRole {
    @Column(name="role_cd", nullable = false)
    private String roleCode;
    @Column(name="role_name", nullable = false)
    private String roleName;
    @Column(name="role_desc", nullable = false)
    private String roleDescription;
}
