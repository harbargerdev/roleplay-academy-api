package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="party_visibility")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PartyVisibility {
    @Column(name="visibility_cd", nullable = false)
    private String visibilityCode;
    @Column(name="visibility_name", nullable = false)
    private String visibilityName;
    @Column(name="visibility_desc", nullable = false)
    private String visibilityDescription;
}
