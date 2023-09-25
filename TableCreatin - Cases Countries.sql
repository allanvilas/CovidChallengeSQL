CREATE TABLE Cases (
	id serial NOT NULL,
	country VARCHAR(50),
	country_code VARCHAR(3),
	continent VARCHAR(50),
	population INT,
	indicator VARCHAR(10),
	year_week VARCHAR(15),
	source VARCHAR(50),
	note TEXT,
	weekly_count INT DEFAULT 0,
	cumulative_count INT DEFAULT 0,
	rate_14_day numeric(10,3) DEFAULT 0.0,
	
	CONSTRAINT PK_id PRIMARY KEY(id)
)

CREATE TABLE Countries (
	id serial not null,
	Country varchar(80),
	Region varchar(80),
	Population int,
	Area int,
	Pop_Density real,
	Coastline real,
	Net_migration real,
	Infant_mortality real,
	GDP int,
	Literacy numeric(10, 6),
	Phones real,
	Arable numeric(10, 6),
	Crops numeric(10, 6),
	Other numeric(10, 6),
	Climate int,
	Birthrate real,
	Deathrate real,
	Agriculture real,
	Industry real,
	Service real,

	CONSTRAINT PK_Countries_id PRIMARY KEY(id)
);