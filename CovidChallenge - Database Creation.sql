BEGIN;


CREATE TABLE IF NOT EXISTS public.cases
(
    id integer NOT NULL DEFAULT nextval('cases_id_seq'::regclass),
    country character varying(50) COLLATE pg_catalog."default",
    country_code character varying(3) COLLATE pg_catalog."default",
    continent character varying(50) COLLATE pg_catalog."default",
    population integer,
    indicator character varying(10) COLLATE pg_catalog."default",
    year_week character varying(15) COLLATE pg_catalog."default",
    source character varying(50) COLLATE pg_catalog."default",
    note text COLLATE pg_catalog."default",
    weekly_count integer DEFAULT 0,
    cumulative_count integer DEFAULT 0,
    rate_14_day numeric(10, 3) DEFAULT 0.0,
    updated_when timestamp without time zone DEFAULT now(),
    CONSTRAINT pk_id PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.countries
(
    country character varying(80) COLLATE pg_catalog."default" NOT NULL,
    region character varying(80) COLLATE pg_catalog."default",
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

CREATE TABLE IF NOT EXISTS public.dm_week_to_date
(
    year_week character varying(8) COLLATE pg_catalog."default" NOT NULL,
    yw_year integer,
    yw_week integer,
    yw_week_first_day date,
    yw_week_last_day date,
    CONSTRAINT pk_wk PRIMARY KEY (year_week)
);

CREATE TABLE IF NOT EXISTS public.vacination
(
    id bigint NOT NULL DEFAULT nextval('vacination_id_seq'::regclass),
    country character varying(60) COLLATE pg_catalog."default",
    iso_code character varying(20) COLLATE pg_catalog."default",
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

ALTER TABLE IF EXISTS public.cases
    ADD CONSTRAINT "FK_YearWeek" FOREIGN KEY (year_week)
    REFERENCES public.dm_week_to_date (year_week) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS "fki_FK_YearWeek"
    ON public.cases(year_week);


ALTER TABLE IF EXISTS public.cases
    ADD CONSTRAINT "Fk_Country" FOREIGN KEY (country)
    REFERENCES public.countries (country) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS "fki_Fk_Country"
    ON public.cases(country);


ALTER TABLE IF EXISTS public.vacination
    ADD CONSTRAINT "FK_Country" FOREIGN KEY (country)
    REFERENCES public.countries (country) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;
CREATE INDEX IF NOT EXISTS "fki_FK_Country"
    ON public.vacination(country);

END;
