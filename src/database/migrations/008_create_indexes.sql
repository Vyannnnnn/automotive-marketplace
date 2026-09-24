CREATE INDEX idx_categories_parent_id
  ON categories (parent_id);

CREATE INDEX idx_category_closure_ancestor
  ON category_closure (ancestor_id);

CREATE INDEX idx_category_closure_descendant
  ON category_closure (descendant_id);

CREATE INDEX idx_models_make_id
  ON models (make_id);

CREATE INDEX idx_listings_category_id
  ON listings (category_id);

CREATE INDEX idx_listings_make_id
  ON listings (make_id);

CREATE INDEX idx_listings_model_id
  ON listings (model_id);

CREATE INDEX idx_listings_city_id
  ON listings (city_id);

CREATE INDEX idx_listings_status
  ON listings (status);

CREATE INDEX idx_listings_price
  ON listings (price);

CREATE INDEX idx_listings_year
  ON listings (year);

CREATE INDEX idx_listings_created_at_id
  ON listings (created_at DESC, id DESC);

CREATE INDEX idx_listing_attributes_attribute_id
  ON listing_attributes (attribute_id);

CREATE INDEX idx_listing_attributes_numeric
  ON listing_attributes (attribute_id, value_numeric);

CREATE INDEX idx_listing_attributes_text
  ON listing_attributes (attribute_id, value_text);

CREATE INDEX idx_listing_attributes_boolean
  ON listing_attributes (attribute_id, value_boolean);

CREATE INDEX idx_listings_search_vector
  ON listings
  USING GIN (search_vector);

  CREATE OR REPLACE FUNCTION listings_search_vector_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.search_vector :=
    setweight(
      to_tsvector(
        'simple',
        COALESCE(NEW.description, '')
      ),
      'C'
    );

  RETURN NEW;
END;
$$;

CREATE TRIGGER trg_listings_search_vector
BEFORE INSERT OR UPDATE OF description
ON listings
FOR EACH ROW
EXECUTE FUNCTION listings_search_vector_update();