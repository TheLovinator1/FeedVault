-- name: CreateFeed :one
INSERT INTO
    feeds (
        "url",
        created_at,
        updated_at,
        deleted_at,
        title,
        "description",
        link,
        feed_link,
        links,
        updated,
        updated_parsed,
        published,
        published_parsed,
        "language",
        copyright,
        generator,
        categories,
        custom,
        feed_type,
        feed_version
    )
VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20
    )
RETURNING
    *;

-- name: CountFeeds :one
SELECT
    COUNT(*)
FROM
    feeds;

-- name: CreateItem :one
INSERT INTO
    items (
        created_at,
        updated_at,
        deleted_at,
        title,
        "description",
        content,
        link,
        links,
        updated,
        updated_parsed,
        published,
        published_parsed,
        "guid",
        categories,
        custom,
        feed_id
    )
VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16
    )
RETURNING
    *;

-- name: CountItems :one
SELECT
    COUNT(*)
FROM
    items;

-- name: GetFeed :one
SELECT
    *
FROM
    feeds
WHERE
    id = $1;

-- name: GetFeeds :many
SELECT
    *
FROM
    feeds
ORDER BY
    created_at DESC
LIMIT
    $1
OFFSET
    $2;

-- name: GetItem :one
SELECT
    *
FROM
    items
WHERE
    id = $1;

-- name: GetItems :many
SELECT
    *
FROM
    items
WHERE
    feed_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: CreateFeedExtension :one
INSERT INTO
    feed_extensions (
        created_at,
        updated_at,
        deleted_at,
        "name",
        "value",
        attrs,
        children,
        feed_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING
    *;

-- name: CreateItemExtension :one
INSERT INTO
    item_extensions (
        created_at,
        updated_at,
        deleted_at,
        "name",
        "value",
        attrs,
        children,
        item_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING
    *;

-- name: GetFeedExtensions :many
SELECT
    *
FROM
    feed_extensions
WHERE
    feed_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: GetItemExtensions :many
SELECT
    *
FROM
    item_extensions
WHERE
    item_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: CreateFeedAuthor :one
INSERT INTO
    feed_authors (
        created_at,
        updated_at,
        deleted_at,
        "name",
        email,
        feed_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: CreateItemAuthor :one
INSERT INTO
    item_authors (
        created_at,
        updated_at,
        deleted_at,
        "name",
        email,
        item_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: GetFeedAuthors :many
SELECT
    *
FROM
    feed_authors
WHERE
    feed_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: GetItemAuthors :many
SELECT
    *
FROM
    item_authors
WHERE
    item_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: CreateFeedImage :one
INSERT INTO
    feed_images (
        created_at,
        updated_at,
        deleted_at,
        "url",
        title,
        feed_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: CreateItemImage :one
INSERT INTO
    item_images (
        created_at,
        updated_at,
        deleted_at,
        "url",
        title,
        item_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: GetFeedImages :many
SELECT
    *
FROM
    feed_images
WHERE
    feed_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: GetItemImages :many
SELECT
    *
FROM
    item_images
WHERE
    item_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: CreateFeedDublinCore :one
INSERT INTO
    feed_dublin_cores (
        created_at,
        updated_at,
        deleted_at,
        title,
        creator,
        author,
        "subject",
        "description",
        publisher,
        contributor,
        "date",
        "type",
        format,
        identifier,
        source,
        "language",
        relation,
        coverage,
        rights,
        feed_id
    )
VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20
    )
RETURNING
    *;

-- name: CreateItemDublinCore :one
INSERT INTO
    item_dublin_cores (
        created_at,
        updated_at,
        deleted_at,
        title,
        creator,
        author,
        "subject",
        "description",
        publisher,
        contributor,
        "date",
        "type",
        format,
        identifier,
        source,
        "language",
        relation,
        coverage,
        rights,
        item_id
    )
VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18,
        $19,
        $20
    )
RETURNING
    *;

-- name: GetFeedDublinCores :many
SELECT
    *
FROM
    feed_dublin_cores
WHERE
    feed_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: GetItemDublinCores :many
SELECT
    *
FROM
    item_dublin_cores
WHERE
    item_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: CreateFeedItunes :one
INSERT INTO
    feed_itunes (
        created_at,
        updated_at,
        deleted_at,
        author,
        "block",
        "explicit",
        keywords,
        subtitle,
        summary,
        "image",
        complete,
        new_feed_url,
        "type",
        feed_id
    )
VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14
    )
RETURNING
    *;

-- name: CreateItemItunes :one
INSERT INTO
    item_itunes (
        created_at,
        updated_at,
        deleted_at,
        author,
        "block",
        "explicit",
        keywords,
        subtitle,
        summary,
        "image",
        is_closed_captioned,
        episode,
        season,
        "order",
        episode_type,
        item_id
    )
VALUES
    (
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16
    )
RETURNING
    *;

-- name: GetFeedItunes :one
SELECT
    *
FROM
    feed_itunes
WHERE
    feed_id = $1;

-- name: GetItemItunes :one
SELECT
    *
FROM
    item_itunes
WHERE
    item_id = $1;

-- name: CreateFeedItunesCategory :one
INSERT INTO
    feed_itunes_categories (
        created_at,
        updated_at,
        deleted_at,
        "text",
        subcategory,
        itunes_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: CreateFeedItunesOwner :one
INSERT INTO
    feed_itunes_owners (
        created_at,
        updated_at,
        deleted_at,
        email,
        "name",
        itunes_id
    )
VALUES
    ($1, $2, $3, $4, $5, $6)
RETURNING
    *;

-- name: GetFeedItunesCategories :many
SELECT
    *
FROM
    feed_itunes_categories
WHERE
    itunes_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;

-- name: GetFeedItunesOwners :many
SELECT
    *
FROM
    feed_itunes_owners
WHERE
    itunes_id = $1
ORDER BY
    created_at DESC
LIMIT
    $2
OFFSET
    $3;
