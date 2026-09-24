CREATE TABLE category_closure (
  ancestor_id UUID NOT NULL
    REFERENCES categories(id)
    ON DELETE CASCADE,

  descendant_id UUID NOT NULL
    REFERENCES categories(id)
    ON DELETE CASCADE,

  depth INTEGER NOT NULL CHECK (depth >= 0),

  PRIMARY KEY (ancestor_id, descendant_id)
);
