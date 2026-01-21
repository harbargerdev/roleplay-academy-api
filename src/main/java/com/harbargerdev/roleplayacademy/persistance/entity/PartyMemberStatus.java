package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="party_member_status")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PartyMemberStatus {
    @Column(name="status_cd", nullable = false)
    private String statusCode;
    @Column(name="status_name", nullable = false)
    private String statusName;
    @Column(name="status_desc", nullable = false)
    private String statusDescription;
}
