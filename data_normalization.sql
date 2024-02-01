-- Normalization to 2NF:
-- Create new tables for each set of partially dependent columns

CREATE TABLE cars.transmission(
id INT AUTO_INCREMENT PRIMARY KEY,
transmission VARCHAR(255),
transmission_type VARCHAR (255)
);

CREATE TABLE cars.body(
id INT AUTO_INCREMENT PRIMARY KEY,
body_type VARCHAR(255),
seating_capacity INT
);

CREATE TABLE cars.fuel(
id INT AUTO_INCREMENT PRIMARY KEY,
fuel_type VARCHAR(255),
fuel_tank_capacity_l INT
);

CREATE TABLE cars.power(
id INT AUTO_INCREMENT PRIMARY KEY,
power_bhp FLOAT,
torque_nm FLOAT
);

CREATE TABLE cars.emission(
id INT AUTO_INCREMENT PRIMARY KEY,
mileage_kmpl FLOAT,
emission VARCHAR(255)
);

CREATE TABLE cars.model(
id INT AUTO_INCREMENT PRIMARY KEY,
make VARCHAR(255),
model VARCHAR (255),
engine_type VARCHAR(255),
cc_displacement INT
);


-- Populate data: copy data from the original table to the new tables

INSERT INTO cars.transmission(transmission, transmission_type)
SELECT DISTINCT transmission, transmission_type
FROM cars.raw_data;

INSERT INTO cars.body(body_type, seating_capacity)
SELECT DISTINCT body_type, seating_capacity
FROM cars.raw_data;

INSERT INTO cars.fuel(fuel_type, fuel_tank_capacity_l)
SELECT DISTINCT fuel_type, fuel_tank_capacity_l
FROM cars.raw_data;

INSERT INTO cars.power(power_bhp, torque_nm)
SELECT DISTINCT power_bhp, torque_nm
FROM cars.raw_data;

INSERT INTO cars.emission(mileage_kmpl, emission)
SELECT DISTINCT mileage_kmpl, emission
FROM cars.raw_data;

INSERT INTO cars.model(make, model, engine_type, cc_displacement)
SELECT DISTINCT make, model, engine_type, cc_displacement
FROM cars.raw_data raw_data;


-- Adjust Original Table: modify the original table by adding foreign key columns that reference the new tables

ALTER TABLE cars.raw_data
ADD COLUMN transmission_id INT
REFERENCES cars.transmission(id);

UPDATE cars.raw_data
SET transmission_id=(
SELECT id
FROM cars.transmission t
WHERE t.transmission=raw_data.transmission
AND t.transmission_type=raw_data.transmission_type)

ALTER TABLE cars.raw_data
ADD COLUMN emission_id INT
REFERENCES cars.emission(id);

UPDATE cars.raw_data
SET emission_id=(
SELECT id
FROM cars.emission e
WHERE e.emission=raw_data.emission
AND e.mileage_kmpl=raw_data.mileage_kmpl)

ALTER TABLE cars.raw_data
ADD COLUMN power_id INT
REFERENCES cars.power(id);

UPDATE cars.raw_data
SET power_id=(
SELECT id
FROM cars.power p
WHERE p.power_bhp=raw_data.power_bhp
AND p.torque_nm=raw_data.torque_nm)

ALTER TABLE cars.raw_data
ADD COLUMN body_id INT
REFERENCES cars.body(id);

UPDATE cars.raw_data
SET body_id=(
SELECT id
FROM cars.body b
WHERE b.body_type=raw_data.body_type
AND b.seating_capacity=raw_data.seating_capacity)

ALTER TABLE cars.raw_data
ADD COLUMN model_id INT
REFERENCES cars.model(id);

UPDATE cars.raw_data
SET model_id=(
SELECT id
FROM cars.model m
WHERE m.make=raw_data.make
AND m.model=raw_data.model
AND m.engine_type=raw_data.engine_type
AND m.cc_displacement=raw_data.cc_displacement)

ALTER TABLE cars.raw_data
ADD COLUMN fuel_id INT
REFERENCES cars.fuel(id);

UPDATE cars.raw_data
SET fuel_id=(
SELECT id
FROM cars.fuel f
WHERE f.fuel_tank_capacity_l=raw_data.fuel_tank_capacity_l
AND f.fuel_type=raw_data.fuel_type)


-- Create new table and insert data from original table 

CREATE TABLE cars.resale(
resale_id SERIAL PRIMARY KEY,
car_name VARCHAR(255),
make_year INT,
color VARCHAR(255),
mileage_run FLOAT,
no_of_owners VARCHAR(255),
price FLOAT,
transmission_id INT,
emission_id INT,
power_id INT,
fuel_id INT,
body_id INT,
model_id INT
);

INSERT INTO cars.resale(car_name, make_year, color, mileage_run, no_of_owners, price,
transmission_id, emission_id, power_id, fuel_id, body_id, model_id)
SELECT car_name, make_year, color, mileage_run, no_of_owners, price,
transmission_id, emission_id, power_id, fuel_id, body_id, model_id
FROM cars.raw_data;


-- Establish relationships (foreign key constraints) between the new tables based on the primary key and foreign key columns

ALTER TABLE cars.resale
ADD FOREIGN KEY (transmission_id) REFERENCES cars.transmission(id);

ALTER TABLE cars.resale
ADD FOREIGN KEY (emission_id) REFERENCES cars.emission(id);

ALTER TABLE cars.resale
ADD FOREIGN KEY (power_id) REFERENCES cars.power(id);

ALTER TABLE cars.resale
ADD FOREIGN KEY (fuel_id) REFERENCES cars.fuel(id);

ALTER TABLE cars.resale
ADD FOREIGN KEY (body_id) REFERENCES cars.body(id);

ALTER TABLE cars.resale
ADD FOREIGN KEY (model_id) REFERENCES cars.model(id);



