BEGIN;

-- A date dimession to references cases through year_week column

CREATE TABLE IF NOT EXISTS public.dm_week_to_date
(
    year_week character varying(8)  NOT NULL,
    yw_year integer,
    yw_week integer,
    yw_week_first_day date,
    yw_week_last_day date,
    CONSTRAINT pk_wk PRIMARY KEY (year_week)
);

END;