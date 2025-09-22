-- H2-compatible user-related table creations and seed data
-- No extensions or search_path in H2

-- Lookup tables
CREATE TABLE IF NOT EXISTS friendship_status (
    status_cd VARCHAR PRIMARY KEY,
    status_name VARCHAR NOT NULL,
    status_desc VARCHAR
);

INSERT INTO friendship_status (status_cd, status_name, status_desc) VALUES
('pending', 'Pending', 'Friend request sent, awaiting response'),
('accepted', 'Accepted', 'Friend request accepted'),
('blocked', 'Blocked', 'User is blocked');

CREATE TABLE IF NOT EXISTS party_visibility (
    status_cd VARCHAR PRIMARY KEY,
    status_name VARCHAR NOT NULL,
    status_desc VARCHAR
);

INSERT INTO party_visibility (status_cd, status_name, status_desc) VALUES
('public', 'Public', 'Anyone can find and join the party'),
('private', 'Private', 'Only invited users can join the party');

CREATE TABLE IF NOT EXISTS party_member_role (
    role_cd VARCHAR PRIMARY KEY,
    role_name VARCHAR NOT NULL,
    role_desc VARCHAR
);

INSERT INTO party_member_role (role_cd, role_name, role_desc) VALUES
('admin', 'Admin', 'Can manage party settings and members'),
('member', 'Member', 'Regular party member');

CREATE TABLE IF NOT EXISTS party_member_status (
    status_cd VARCHAR PRIMARY KEY,
    status_name VARCHAR NOT NULL,
    status_desc VARCHAR
);

INSERT INTO party_member_status (status_cd, status_name, status_desc) VALUES
('active', 'Active', 'Active party member'),
('inactive', 'Inactive', 'Inactive party member');

CREATE TABLE IF NOT EXISTS party_invite_status (
    status_cd VARCHAR PRIMARY KEY,
    status_name VARCHAR NOT NULL,
    status_desc VARCHAR
);

INSERT INTO party_invite_status (status_cd, status_name, status_desc) VALUES
('pending', 'Pending', 'Invite sent, awaiting response'),
('accepted', 'Accepted', 'Invite accepted'),
('expired', 'Expired', 'Invite has expired'),
('revoked', 'Revoked', 'Invite has been revoked');

-- Profile table
CREATE TABLE IF NOT EXISTS profile (
    id VARCHAR(36) PRIMARY KEY,
    handle VARCHAR UNIQUE NOT NULL,
    display_name VARCHAR,
    avatar_url VARCHAR,
    auth_provider VARCHAR NOT NULL,
    auth_subject VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Friendship table
CREATE TABLE IF NOT EXISTS friendship (
    user_id VARCHAR(36) NOT NULL,
    friend_id VARCHAR(36) NOT NULL,
    fr_status_cd VARCHAR NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    CHECK (user_id <> friend_id),
    CHECK (user_id < friend_id),
    FOREIGN KEY (user_id) REFERENCES profile(id),
    FOREIGN KEY (friend_id) REFERENCES profile(id),
    FOREIGN KEY (fr_status_cd) REFERENCES friendship_status(status_cd)
);

-- Party table
CREATE TABLE IF NOT EXISTS party (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR NOT NULL,
    slug VARCHAR UNIQUE NOT NULL,
    visibility_cd VARCHAR NOT NULL,
    created_by VARCHAR(36) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (visibility_cd) REFERENCES party_visibility(status_cd),
    FOREIGN KEY (created_by) REFERENCES profile(id)
);

-- PartyMembership table
CREATE TABLE IF NOT EXISTS party_membership (
    party_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    role_cd VARCHAR NOT NULL,
    party_mbr_status_cd VARCHAR NOT NULL,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (party_id, user_id),
    FOREIGN KEY (party_id) REFERENCES party(id),
    FOREIGN KEY (user_id) REFERENCES profile(id),
    FOREIGN KEY (role_cd) REFERENCES party_member_role(role_cd),
    FOREIGN KEY (party_mbr_status_cd) REFERENCES party_member_status(status_cd)
);

-- PartyInvite table
CREATE TABLE IF NOT EXISTS party_invite (
    id VARCHAR(36) PRIMARY KEY,
    party_id VARCHAR(36) NOT NULL,
    invited_user_id VARCHAR(36),
    token VARCHAR(36) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    party_invite_status_cd VARCHAR NOT NULL,
    FOREIGN KEY (party_id) REFERENCES party(id),
    FOREIGN KEY (invited_user_id) REFERENCES profile(id),
    FOREIGN KEY (party_invite_status_cd) REFERENCES party_invite_status(status_cd)
);

-- Indexes (H2 creates indexes for PK and UNIQUE automatically)
-- No GIN/trigram indexes in H2

