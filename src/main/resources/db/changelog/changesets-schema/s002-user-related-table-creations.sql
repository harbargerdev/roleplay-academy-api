-- Enable citext extension for case-insensitive fields
CREATE EXTENSION IF NOT EXISTS citext;

-- Create schema
SET search_path TO roleplayacademy;

-- Lookup tables
CREATE TABLE IF NOT EXISTS friendship_status (
    status_cd TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    status_desc TEXT
);

INSERT INTO friendship_status (status_cd, status_name, status_desc) VALUES
('pending', 'Pending', 'Friend request sent, awaiting response'),
('accepted', 'Accepted', 'Friend request accepted'),
('blocked', 'Blocked', 'User is blocked');

CREATE TABLE IF NOT EXISTS party_visibility (
    status_cd TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    status_desc TEXT
);

INSERT INTO party_visibility (status_cd, status_name, status_desc) VALUES
('public', 'Public', 'Anyone can find and join the party'),
('private', 'Private', 'Only invited users can join the party');

CREATE TABLE IF NOT EXISTS party_member_role (
    role_cd TEXT PRIMARY KEY,
    role_name TEXT NOT NULL,
    role_desc TEXT
);

INSERT INTO party_member_role (role_cd, role_name, role_desc) VALUES
('admin', 'Admin', 'Can manage party settings and members'),
('member', 'Member', 'Regular party member');

CREATE TABLE IF NOT EXISTS party_member_status (
    status_cd TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    status_desc TEXT
);

INSERT INTO party_member_status (status_cd, status_name, status_desc) VALUES
('active', 'Active', 'Active party member'),
('inactive', 'Inactive', 'Inactive party member');

CREATE TABLE IF NOT EXISTS party_invite_status (
    status_cd TEXT PRIMARY KEY,
    status_name TEXT NOT NULL,
    status_desc TEXT
);

INSERT INTO party_invite_status (status_cd, status_name, status_desc) VALUES
('pending', 'Pending', 'Invite sent, awaiting response'),
('accepted', 'Accepted', 'Invite accepted'),
('expired', 'Expired', 'Invite has expired'),
('revoked', 'Revoked', 'Invite has been revoked');

-- Profile table
CREATE TABLE IF NOT EXISTS profile (
    id UUID PRIMARY KEY,
    handle CITEXT UNIQUE NOT NULL,
    display_name TEXT,
    avatar_url TEXT,
    auth_provider TEXT NOT NULL,
    auth_subject TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ
);

-- Friendship table
CREATE TABLE IF NOT EXISTS friendship (
    user_id UUID NOT NULL,
    friend_id UUID NOT NULL,
    fr_status_cd TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, friend_id),
    CHECK (user_id <> friend_id),
    CHECK (user_id < friend_id),
    FOREIGN KEY (user_id) REFERENCES profile(id) ON DELETE RESTRICT,
    FOREIGN KEY (friend_id) REFERENCES profile(id) ON DELETE RESTRICT,
    FOREIGN KEY (fr_status_cd) REFERENCES friendship_status(status_cd) ON DELETE RESTRICT
);

-- Party table
CREATE TABLE IF NOT EXISTS party (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    slug CITEXT UNIQUE NOT NULL,
    visibility_cd TEXT NOT NULL,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (visibility_cd) REFERENCES party_visibility(status_cd) ON DELETE RESTRICT,
    FOREIGN KEY (created_by) REFERENCES profile(id) ON DELETE RESTRICT
);

-- PartMembership table
CREATE TABLE IF NOT EXISTS party_membership (
    party_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role_cd TEXT NOT NULL,
    party_mbr_status_cd TEXT NOT NULL,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (party_id, user_id),
    FOREIGN KEY (party_id) REFERENCES party(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES profile(id) ON DELETE RESTRICT,
    FOREIGN KEY (role_cd) REFERENCES party_member_role(role_cd) ON DELETE RESTRICT,
    FOREIGN KEY (party_mbr_status_cd) REFERENCES party_member_status(status_cd) ON DELETE RESTRICT
);

-- PartMembership table
CREATE TABLE IF NOT EXISTS party_invite (
    id UUID PRIMARY KEY,
    party_id UUID NOT NULL,
    invited_user_id UUID,
    token UUID UNIQUE NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    party_invite_status_cd TEXT NOT NULL,
    FOREIGN KEY (party_id) REFERENCES party(id) ON DELETE CASCADE,
    FOREIGN KEY (invited_user_id) REFERENCES profile(id) ON DELETE SET NULL,
    FOREIGN KEY (party_invite_status_cd) REFERENCES party_invite_status(status_cd) ON DELETE RESTRICT
);

-- Indexes for search and integrity
CREATE INDEX IF NOT EXISTS idx_friendship_user_id ON friendship(user_id);
CREATE INDEX IF NOT EXISTS idx_friendship_friend_id ON friendship(friend_id);
CREATE INDEX IF NOT EXISTS idx_friendship_accepted ON friendship(user_id, friend_id) WHERE fr_status_cd = 'accepted';
CREATE INDEX IF NOT EXISTS idx_party_membership_user_id ON party_membership(user_id);
CREATE INDEX IF NOT EXISTS idx_party_membership_party_id ON party_membership(party_id);
CREATE INDEX IF NOT EXISTS idx_party_membership_active ON party_membership(party_id, user_id) WHERE party_mbr_status_cd = 'active';

-- Optional: GIN trigram index for search (requires pg_trgm extension)
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_profile_handle_trgm ON profile USING gin(handle gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_party_name_trgm ON party USING gin(name gin_trgm_ops);

-- Data integrity triggers and rules can be added separately for updated_at, invite lifecycle, etc.
-- Row-level security can be enabled as needed for API-facing tables.
-- Soft deletes are handled via deleted_at columns; queries should filter accordingly.
