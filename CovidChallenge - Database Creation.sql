BEGIN;
-- Tables
-- Main table cases
CREATE TABLE IF NOT EXISTS public.cases
(
    id integer NOT NULL DEFAULT nextval('cases_id_seq'::regclass),
    country character varying(50) ,
    country_code character varying(3) ,
    continent character varying(50) ,
    population integer,
    indicator character varying(10) ,
    year_week character varying(15) ,
    source character varying(50) ,
    note text ,
    weekly_count integer DEFAULT 0,
    cumulative_count integer DEFAULT 0,
    rate_14_day numeric(10, 3) DEFAULT 0.0,
    updated_when timestamp without time zone DEFAULT now(),
    CONSTRAINT pk_id PRIMARY KEY (id)
);

-- table countries
CREATE TABLE IF NOT EXISTS public.countries
(
    country character varying(80)  NOT NULL,
    region character varying(80) ,
    population integer,
    area integer,
    pop_density real,
    coastline real,
    net_migration real,
    infant_mortality real,
    gdp integer,
    literacy numeric(5, 2),
    phones real,
    arable numeric(5, 2),
    crops numeric(5, 2),
    other numeric(5, 2),
    climate real,
    birthrate real,
    deathrate real,
    agriculture real,
    industry real,
    service real,
    CONSTRAINT "PK_Country" PRIMARY KEY (country)
);

-- A date transform dimession table to references cases through year_week column
CREATE TABLE IF NOT EXISTS public.dm_week_to_date
(
    year_week character varying(8)  NOT NULL,
    yw_year integer,
    yw_week integer,
    yw_week_first_day date,
    yw_week_last_day date,
    CONSTRAINT pk_wk PRIMARY KEY (year_week)
);

-- table vacination used to enrich the cases data 
CREATE TABLE IF NOT EXISTS public.vacination
(
    id bigint NOT NULL DEFAULT nextval('vacination_id_seq'::regclass),
    country character varying(60) ,
    iso_code character varying(20) ,
    date date,
    total_vaccinations bigint,
    people_vaccinated bigint,
    people_fully_vaccinated bigint,
    total_boosters bigint,
    daily_vaccinations_raw bigint,
    daily_vaccinations real,
    total_vaccinations_per_hundred real,
    people_vaccinated_per_hundred real,
    people_fully_vaccinated_per_hundred real,
    total_boosters_per_hundred real,
    daily_vaccinations_per_million bigint,
    daily_people_vaccinated bigint,
    daily_people_vaccinated_per_hundred real,
    update_on timestamp without time zone DEFAULT now(),
    CONSTRAINT pk_vcn PRIMARY KEY (id)
);

-- Constraints

-- CASES FK Cases.year_week -> dm_week_to_date.year_week
ALTER TABLE IF EXISTS public.cases
    ADD CONSTRAINT "FK_YearWeek" FOREIGN KEY (year_week)
    REFERENCES public.dm_week_to_date (year_week) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS "fki_FK_YearWeek"
    ON public.cases(year_week);

-- CASES FK Cases.country -> Countries.country
ALTER TABLE IF EXISTS public.cases
    ADD CONSTRAINT "Fk_Country" FOREIGN KEY (country)
    REFERENCES public.countries (country) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS "fki_Fk_Country"
    ON public.cases(country);

-- CASES FK Vacination.country -> Countries.country
ALTER TABLE IF EXISTS public.vacination
    ADD CONSTRAINT "FK_Country" FOREIGN KEY (country)
    REFERENCES public.countries (country) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS "fki_FK_Country"
    ON public.vacination(country);

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

-- TRIGGERS

-- Table triggers

CREATE OR REPLACE TRIGGER set_allways_upper
    BEFORE INSERT OR UPDATE 
    ON public.cases
    FOR EACH ROW
    EXECUTE FUNCTION public.allways_upper();

CREATE OR REPLACE TRIGGER set_when_update
    BEFORE UPDATE 
    ON public.cases
    FOR EACH ROW
    EXECUTE FUNCTION public.update_when();

CREATE OR REPLACE TRIGGER set_allways_upper_vcn
    BEFORE INSERT OR UPDATE 
    ON public.vacination
    FOR EACH ROW
    EXECUTE FUNCTION public.allways_upper();

CREATE OR REPLACE TRIGGER set_allways_upper_ct
    BEFORE INSERT OR UPDATE 
    ON public.countries
    FOR EACH ROW
    EXECUTE FUNCTION public.allways_upper();
END;
