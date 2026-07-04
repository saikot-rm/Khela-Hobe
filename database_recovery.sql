-- database_recovery.sql
-- Rebuild the khelahobe MySQL database and seed it with the requested Dhaka turf venues.

CREATE DATABASE IF NOT EXISTS khelahobe;
USE khelahobe;

DROP TABLE IF EXISTS venues;
CREATE TABLE venues (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  landowner_id INT UNSIGNED NOT NULL DEFAULT 1,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  address VARCHAR(255) NOT NULL,
  hourly_rate DECIMAL(10,2) NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  map_link VARCHAR(500) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If your existing venues table already exists, use the following instead of the CREATE TABLE above:
-- ALTER TABLE venues
--   ADD COLUMN IF NOT EXISTS image_url VARCHAR(255) NULL,
--   ADD COLUMN IF NOT EXISTS map_link VARCHAR(500) NULL;

INSERT INTO venues (landowner_id, title, description, address, hourly_rate, image_url, map_link) VALUES
(1, 'ALPHA Sports Mohammadpur', 'Premium turf with clean facilities and evening match lighting.', 'Mohammadpur, Dhaka', 1200.00, 'assets/images/ALPHA Sports- Mohammadpur.jpg', 'https://maps.google.com/?q=ALPHA+Sports+Mohammadpur+Dhaka'),
(1, 'Chatto Turf', 'Comfortable turf with fast playing surface and easy access.', '2 No. Gate More, Chattogram', 1600.00, 'assets/images/chato turf.jpg', 'https://maps.google.com/?q=Chatto+Turf'),
(1, 'Courtside 100ft', 'High-quality turf with a polished pitch and modern amenities.', '100ft Madani Avenue, Dhaka', 2500.00, 'assets/images/Courtside 100ft.jpg', 'https://maps.google.com/?q=Courtside+Madani+Avenue+Dhaka'),
(1, 'Dhaka Metroplex 300ft', 'Spacious field ideal for larger groups and match-day events.', '300ft Road, Dhaka', 3500.00, 'assets/images/Dhaka Metroplex 300ft.jpg', 'https://maps.google.com/?q=Dhaka+Metroplex+300ft'),
(1, 'DSF Dhanmondi', 'Popular turf in a central area with strong booking support.', 'Dhanmondi, Dhaka', 1500.00, 'assets/images/DSF Dhanmondi.jpg', 'https://maps.google.com/?q=DSF+Dhanmondi'),
(1, 'JAFF', 'Well-known arena with excellent turf quality and easy access.', 'Bashundhara R/A, Dhaka', 3000.00, 'assets/images/JAFF.jpg', 'https://maps.google.com/?q=JAFF+Arena+Bashundhara+Dhaka'),
(1, 'NDE Futsal Field', 'Great for casual and competitive play with a compact layout.', 'Bashundhara R/A, Dhaka', 2000.00, 'assets/images/NDE Futsal Field.jpg', 'https://maps.google.com/?q=NDE+Sports+Facility+Bashundhara'),
(1, 'Sports Grill', 'Good choice for evening sessions with a lively sports atmosphere.', 'Tejgaon, Dhaka', 3500.00, 'assets/images/sports grill.jpg', 'https://maps.google.com/?q=Sports+Grill+Tejgaon+Dhaka'),
(1, 'The Stadium', 'Modern turf venue with premium pitch quality and facilities.', 'Bashundhara R/A, Dhaka', 3000.00, 'assets/images/stadium.jpg', 'https://maps.google.com/?q=The+Stadium+Bashundhara+Dhaka'),
(1, 'Turf Ground Uttara', 'Large turf setup with good access in the northern part of the city.', 'Sector 4, Uttara, Dhaka', 5300.00, 'assets/images/Turf Ground Uttara.jpg', 'https://maps.google.com/?q=Turf+Ground+Uttara+Dhaka');
