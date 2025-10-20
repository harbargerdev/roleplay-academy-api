package com.harbargerdev.roleplayacademy.persistance.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name="friendship_status")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FriendshipStatus {
    @Id
    private String statusCode;
    @Column(nullable = false)
    private String statusName;
    @Column(nullable = false)
    private String statusDescription;
}
