-- ---------------------------------------------
-- users table
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id uuid NOT NULL,
    email varchar(255) NOT NULL,
    password_hash varchar(255) NOT NULL,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamptz,
    CONSTRAINT pk_users PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_users_email
ON users (email);

CREATE INDEX IF NOT EXISTS idx_users_deleted_at
ON users (deleted_at);

CREATE UNIQUE INDEX IF NOT EXISTS uidx_users_email_deleted_at
ON users (email)
WHERE
deleted_at IS NULL;


-- ---------------------------------------------
-- gender enum
-- ---------------------------------------------
CREATE TYPE gender AS ENUM (
    'm',
    'f'
);


-- ---------------------------------------------
-- profiles table
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS profiles (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    full_name varchar(127),
    photo_url varchar(255),
    bio varchar(255),
    gender gender,
    birth_date date,
    occupation varchar(63),
    organization varchar(63),
    location varchar(255),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_profiles
    PRIMARY KEY (id),

    CONSTRAINT uq_profiles_user_id
    UNIQUE (user_id),

    CONSTRAINT fk_profiles_user_id
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_profiles_user_id
ON profiles (user_id);


-- ---------------------------------------------
-- roles table
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS roles (
    id uuid NOT NULL,
    name varchar(32) NOT NULL,

    CONSTRAINT pk_roles
    PRIMARY KEY (id),

    CONSTRAINT uq_roles_name
    UNIQUE (name)
);


-- ---------------------------------------------
-- user_roles table (relation: users - roles)
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,

    CONSTRAINT pk_user_roles
    PRIMARY KEY (user_id, role_id),

    CONSTRAINT fk_user_roles_user_id
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE,

    CONSTRAINT fk_user_roles_role_id
    FOREIGN KEY (role_id)
    REFERENCES roles (id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id
ON user_roles (user_id);

CREATE INDEX IF NOT EXISTS idx_user_roles_role_id
ON user_roles (role_id);


-- ---------------------------------------------
-- permissions table
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS permissions (
    id varchar(63) NOT NULL,

    CONSTRAINT pk_permissions
    PRIMARY KEY (id)
);


-- ---------------------------------------------
-- user_permissions table (relation: users - permissions)
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS user_permissions (
    user_id uuid NOT NULL,
    permission_id uuid NOT NULL,

    CONSTRAINT pk_user_permissions
    PRIMARY KEY (user_id, permission_id),

    CONSTRAINT fk_user_permissions_user_id
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE,

    CONSTRAINT fk_user_permissions_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permissions (id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_permissions_user_id
ON user_permissions (user_id);


-- ---------------------------------------------
-- role_permissions table (relation: roles - permissions)
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,

    CONSTRAINT pk_role_permissions
    PRIMARY KEY (role_id, permission_id),

    CONSTRAINT fk_role_permissions_role_id
    FOREIGN KEY (role_id)
    REFERENCES roles (id)
    ON DELETE CASCADE,

    CONSTRAINT fk_role_permissions_permission_id
    FOREIGN KEY (permission_id)
    REFERENCES permissions (id)
    ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_role_permissions_role_id
ON role_permissions (role_id);


-- ---------------------------------------------
-- plants table
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS plants (
    id uuid PRIMARY KEY,
    scitentific_name varchar(127) NOT NULL,

    CONSTRAINT uq_plants_scientific_name
        UNIQUE (scitentific_name)
);


-- ---------------------------------------------
-- pests table
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS pests (
    id uuid PRIMARY KEY,
    scitentific_name varchar(127) NOT NULL,

    CONSTRAINT uq_pests_scientific_name
        UNIQUE (scitentific_name)
);


CREATE TABLE IF NOT EXISTS image_classifications (
	id uuid PRIMARY KEY,
	plant_id uuid NOT NULL,
	disease_id uuid NOT NULL,
	hash varchar(255) NOT NULL,
	categories varchar(255) NOT NULL
)


