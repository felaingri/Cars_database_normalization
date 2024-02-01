-- Create a new user
CREATE USER 'analyst'@'localhost'
IDENTIFIED BY 'analyst01';

-- Grant select privelige (only read) on specific tables
GRANT SELECT ON cars.body  TO 'analyst'@'localhost';
GRANT SELECT ON cars.emission  TO 'analyst'@'localhost';
GRANT SELECT ON cars.fuel  TO 'analyst'@'localhost';
GRANT SELECT ON cars.model  TO 'analyst'@'localhost';
GRANT SELECT ON cars.power  TO 'analyst'@'localhost';
GRANT SELECT ON cars.resale  TO 'analyst'@'localhost';
GRANT SELECT ON cars.transmission  TO 'analyst'@'localhost';

-- After granting priviliges apply the changes
FLUSH PRIVILEGES;

