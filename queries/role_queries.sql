-- name: CountRoleByID :one
SELECT COUNT(*)
FROM
    roles
WHERE
    id = $1;
