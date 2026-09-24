CREATE TABLE listing_attributes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  listing_id UUID NOT NULL
    REFERENCES listings(id)
    ON DELETE CASCADE,

  attribute_id UUID NOT NULL
    REFERENCES filter_attributes(id)
    ON DELETE RESTRICT,

  value_text TEXT,

  value_numeric NUMERIC,

  value_boolean BOOLEAN,

  CONSTRAINT uq_listing_attribute
    UNIQUE (listing_id, attribute_id),

  CONSTRAINT chk_listing_attribute_single_value
    CHECK (
      (
        value_text IS NOT NULL
        AND value_numeric IS NULL
        AND value_boolean IS NULL
      )
      OR
      (
        value_text IS NULL
        AND value_numeric IS NOT NULL
        AND value_boolean IS NULL
      )
      OR
      (
        value_text IS NULL
        AND value_numeric IS NULL
        AND value_boolean IS NOT NULL
      )
    )
);