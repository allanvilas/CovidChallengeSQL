BEGIN;

-- trigger functions

-- Fix all countries to UPPERCASE

CREATE OR REPLACE FUNCTION allways_upper()
   RETURNS trigger AS $$
BEGIN
	NEW.country = UPPER(NEW.country) ;
	RETURN NEW;
END;
$$;

-- Update the column when updated

CREATE OR REPLACE FUNCTION update_when()
   RETURNS trigger AS $$
BEGIN
	NEW.updated_when = NOW();
	RETURN NEW;
END;
$$;

END;