CREATE TABLE filter_attributes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  name VARCHAR(100) NOT NULL,

  slug VARCHAR(120) NOT NULL UNIQUE,

  type VARCHAR(20) NOT NULL
    CHECK (
      type IN (
        'enum',
        'range',
        'boolean'
      )
    ),

  unit VARCHAR(30),

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE filter_attribute_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  attribute_id UUID NOT NULL
    REFERENCES filter_attributes(id)
    ON DELETE CASCADE,

  label VARCHAR(100) NOT NULL,

  value VARCHAR(100) NOT NULL,

  CONSTRAINT uq_filter_attribute_option
    UNIQUE (attribute_id, value)
);

CREATE TABLE category_filter_attributes (
  category_id UUID NOT NULL
    REFERENCES categories(id)
    ON DELETE CASCADE,

  attribute_id UUID NOT NULL
    REFERENCES filter_attributes(id)
    ON DELETE CASCADE,

  required BOOLEAN NOT NULL DEFAULT FALSE,

  PRIMARY KEY (category_id, attribute_id)
);