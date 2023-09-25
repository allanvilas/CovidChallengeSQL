BEGIN;

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

    -- CASES FK Vacination.country -> Countries.country
    ALTER TABLE IF EXISTS public.vacination
        ADD CONSTRAINT "FK_Country" FOREIGN KEY (country)
        REFERENCES public.countries (country) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;
    CREATE INDEX IF NOT EXISTS "fki_FK_Country"
        ON public.vacination(country);

    -- BEFORE EXECUTING THE COMMANDS BELOW
    -- EXECUTE THE CovidChallenge - TriggerFuncions.sql

    CREATE OR REPLACE TRIGGER set_allways_upper_vcn
        BEFORE INSERT OR UPDATE 
        ON public.vacination
        FOR EACH ROW
        EXECUTE FUNCTION public.allways_upper();
END;