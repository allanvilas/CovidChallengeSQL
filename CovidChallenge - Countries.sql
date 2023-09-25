BEGIN;

    -- Table Countries
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

    -- BEFORE EXECUTING THE COMMANDS BELOW
    -- EXECUTE THE CovidChallenge - TriggerFuncions.sql

    CREATE OR REPLACE TRIGGER set_allways_upper_ct
        BEFORE INSERT OR UPDATE 
        ON public.countries
        FOR EACH ROW
        EXECUTE FUNCTION public.allways_upper();
END;