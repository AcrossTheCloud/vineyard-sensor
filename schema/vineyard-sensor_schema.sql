-- PostgreSQL/PostGIS Schema for vineyard sensors

-- Store data about each sensor
CREATE TABLE sensor_metadata(
id serial NOT NULL,
height_above_riverbed real NOT NULL,
location geometry(Point,4326),
CONSTRAINT sensors_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE sensor_metadata IS 'Information about individual sensors';
COMMENT ON COLUMN sensor_metadata.id IS '{serial} [Primary Key] Unique key for each sensor';
COMMENT ON COLUMN sensor_metadata.height_above_riverbed IS '{real} Height between riverbed and sensor in cm';
COMMENT ON COLUMN sensor_metadata.location IS '{geometry object} Point location for sensor using WGS1984 coordinate reference system';
-- Index sensor locations for spatial queries
CREATE INDEX gix_sensor_metadata
ON sensor_metadata
USING gist(location);

--Store sensor measurements
CREATE TABLE sensor_data(
id bigserial NOT NULL,
sensor_id integer NOT NULL,
measurement_time timestamp with time zone NOT NULL,
database_time timestamp with time zone DEFAULT now(),
soil_moisture float,
sap_flow float,
CONSTRAINT sensor_data_pkey PRIMARY KEY (id)
);
COMMENT ON TABLE sensor_data IS 'Measurements from individual sensors';
COMMENT ON COLUMN sensor_data.id IS '{integer} [Primary Key] Unique key for each sensor';
COMMENT ON COLUMN sensor_data.measurement_time IS '{timestamp with timezone} Time of measurement as recorded by sensor';
COMMENT ON COLUMN sensor_data.database_time IS '{timestamp with timezone} Time measurement data entered into database';
COMMENT ON COLUMN sensor_data.soil_moisture IS '{float} soil moisture measurement';
COMMENT ON COLUMN sensor_data.sap_flow IS '{float} sap flow measurement';


-- Create types for floodsensor data output
CREATE TYPE sensor_data_type AS (
  measurement_time timestamp,
  distance double precision,
  soil_moisture double precision,
  sap_flow double precision
);

CREATE TYPE sensor_metadata_type AS (
	id varchar,
	measurements json
);
