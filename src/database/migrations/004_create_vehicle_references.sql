CREATE TABLE makes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  name VARCHAR(100) NOT NULL,

  slug VARCHAR(120) NOT NULL UNIQUE,

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE models (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  make_id UUID NOT NULL
    REFERENCES makes(id)
    ON DELETE RESTRICT,

  name VARCHAR(100) NOT NULL,

  slug VARCHAR(120) NOT NULL,

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT uq_models_make_slug
    UNIQUE (make_id, slug)
);

CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  name VARCHAR(100) NOT NULL,

  slug VARCHAR(120) NOT NULL UNIQUE,

  province VARCHAR(100) NOT NULL
);