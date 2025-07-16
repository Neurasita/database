-- name: CreateUser :one
WITH gen_user_id AS (
    INSERT INTO users (id, email, password_hash)
    VALUES ($1, $2, $3)
    RETURNING
        id
)

INSERT INTO user_roles (user_id, role_id)
SELECT
    id AS user_id,
    $4 AS role_id
FROM
    gen_user_id
RETURNING
    user_id;

-- name: GetUserByID :one
SELECT
    id,
    email,
    created_at,
    updated_at
FROM
    users
WHERE
    id = $1
    AND deleted_at IS NULL
LIMIT 1;

-- name: GetUserCredsByEmail :one
SELECT
    id,
    password_hash
FROM
    users
WHERE
    email = $1
    AND deleted_at IS NULL
LIMIT 1;

-- name: UpdateUserPassword :one
UPDATE
    users
SET
    password_hash = $2
WHERE
    id = $1
    AND deleted_at IS NULL
RETURNING
    id;

-- name: UpdateUserEmail :one
UPDATE
    users
SET
    email = $2
WHERE
    id = $1
    AND deleted_at IS NULL
RETURNING
    id;

-- name: DeleteUser :one
DELETE FROM users
WHERE
    id = $1
    AND deleted_at IS NULL
RETURNING
    id;
