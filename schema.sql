CREATE TABLE trails (
	id serial PRIMARY KEY,
	name text NOT NULL,
	distance_round_trip decimal(4,2),
	distance_units varchar(20) DEFAULT 'miles',
	elevation_gain integer,
	avg_round_trip_time decimal(4, 2),
	avg_rtt_units varchar(20) DEFAULT 'hours'
);

CREATE TABLE users (
	id serial PRIMARY KEY,
	name text NOT NULL,
	password text NOT NULL
);

CREATE TABLE users_trails (
	id serial PRIMARY KEY,
	favorited_trail_flag boolean DEFAULT FALSE,
	number_of_visits integer,
	trail_id integer NOT NULL,
	user_id integer NOT NULL,
	FOREIGN KEY (trail_id) REFERENCES trails (id) ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Tramonto Trail, AZ', 3.84, 131, 2.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Great Horned Owl Trail - Sonoran Preserve, AZ', 6.0, 204, 3.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Scarlett Ridgeline Loop, AZ', NULL, 157, 1.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Geronimo Trail - South Mountain, AZ', 5.1, 1091, 3.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('National Trail - Telegraph to Pima, AZ', 16.2, 1200, 8.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Gila Trail - South Mountain, AZ', 7.2, 466, 0.05);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Lookout Mountain Summit Trail #150, AZ', 0.98, 436, 0.75);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Camelback Summit - Echo Canyon TH, AZ', 2.3, 1300, 1.5);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Mummy Mountain, AZ', 1.51, 794, 1.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Hole in the Rock - Papago Park, AZ', 0.28, 71, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Lookout Mtn Circumference Trail #308, AZ', 2.7, 210, 1.5);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Maxine Lakin Nature Trail, AZ', NULL, 110, 0.5);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('North Mountain National Trail #44, AZ', 2.7, 626, 1.17);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Buffalo Ridge Summit, Western Prominence, AZ', 0.8, 258, 0.75);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Flume Trail - CCRP, AZ', 5.0, 190, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Black Mountain - Cave Creek, AZ', 2.5, 1165, 1.25);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Spur Cross Trail, AZ', 10.6, NULL, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Tom''s Thumb Loop off Windgate Pass Trail, AZ', NULL, 2190, 6.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Pinnacle Peak, AZ', 3.58, 509, 1.5);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Apache Creek Trail #9905, AZ', 11.2, 267, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Quartz Peak Trail - Sierra Estrella, AZ', 5.2, 2494, 3.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Boulder Canyon Trail #103, AZ', 14.6, 650, 7.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Hieroglyphics Trail #101, AZ', 3.0, 588, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Peralta Trail #102, AZ', 12.4, 1450, 6.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Vulture Peak, AZ', 4.2, 1155, 2.5);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Silly Mountain Circumference, AZ', 2.36, 354, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Wind Cave Trail #281, AZ', 3.2, 763, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Sophie''s Flat Trails A+D, AZ', NULL, 288, 6.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Siphon Draw Trail #53, AZ', 3.9, 1070, 2.0);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Cave Creek Trail #4, AZ', 9.2, 839, NULL);
INSERT INTO trails (name, distance_round_trip, elevation_gain, avg_round_trip_time)
	VALUES ('Mount Ord from Bushnell Tanks TH, AZ', NULL, 3136, 10.0);
