-- question 5
CREATE TABLE vacination (
	id bigserial not null,
	country VARCHAR(60),
	iso_code VARCHAR(20),
	date date,
	total_vaccinations BIGINT,
	people_vaccinated BIGINT,
	people_fully_vaccinated BIGINT,
	total_boosters BIGINT,
	daily_vaccinations_raw BIGINT,
	daily_vaccinations real,
	total_vaccinations_per_hundred real,
	people_vaccinated_per_hundred real,
	people_fully_vaccinated_per_hundred real,
	total_boosters_per_hundred real,
	daily_vaccinations_per_million BIGINT,
	daily_people_vaccinated BIGINT,
	daily_people_vaccinated_per_hundred real,
	update_on timestamp DEFAULT NOW(),
	
	CONSTRAINT PK_VCN PRIMARY KEY(id)
)
