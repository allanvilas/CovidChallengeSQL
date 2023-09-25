BEGIN;

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

    -- BEFORE EXECUTING THE COMMANDS BELOW
    -- EXECUTE THE CovidChallenge - TriggerFuncions.sql

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

END;