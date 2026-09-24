CREATE TABLE listings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  category_id UUID NOT NULL
    REFERENCES categories(id)
    ON DELETE RESTRICT,

  make_id UUID NOT NULL
    REFERENCES makes(id)
    ON DELETE RESTRICT,

  model_id UUID NOT NULL
    REFERENCES models(id)
    ON DELETE RESTRICT,

  city_id UUID NOT NULL
    REFERENCES cities(id)
    ON DELETE RESTRICT,

  year SMALLINT NOT NULL
    CHECK (year >= 1886),

  mileage INTEGER NOT NULL
    CHECK (mileage >= 0),

  price BIGINT NOT NULL
    CHECK (price > 0),

  condition VARCHAR(30) NOT NULL
    CHECK (
      condition IN (
        'new',
        'used'
      )
    ),

  transmission VARCHAR(30) NOT NULL
    CHECK (
      transmission IN (
        'manual',
        'automatic',
        'cvt',
        'amt'
      )
    ),

  fuel_type VARCHAR(30) NOT NULL
    CHECK (
      fuel_type IN (
        'gasoline',
        'diesel',
        'hybrid',
        'electric'
      )
    ),

  color VARCHAR(50) NOT NULL,

  description TEXT NOT NULL,

  status VARCHAR(30) NOT NULL DEFAULT 'available'
    CHECK (
      status IN (
        'available',
        'pending',
        'sold',
        'removed'
      )
    ),

  search_vector TSVECTOR,

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE listing_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  listing_id UUID NOT NULL
    REFERENCES listings(id)
    ON DELETE CASCADE,

  url TEXT NOT NULL,

  sort_order SMALLINT NOT NULL DEFAULT 0
    CHECK (sort_order >= 0),

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);