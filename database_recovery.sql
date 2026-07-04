-- database_recovery.sql
-- Rebuild the khelahobe MySQL database and seed it with Dhaka turf venues.

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

INSERT INTO venues (landowner_id, title, description, address, hourly_rate, image_url, map_link) VALUES
(1, 'ALPHA Sports Mohammadpur', 'Premium turf with floodlights and synthetic grass ideal for evening matches.', 'Mohammadpur, Dhaka 1207', 1500.00, 'assets/images/alpha_sports_mohammadpur.jpg', 'https://www.google.com/maps/place/ALPHA+Sports+Mohammadpur'),
(1, 'Chatto Turf', 'Spacious 5-a-side ground with fast grass and spectator seating.', 'Kawran Bazar Rd, Dhaka 1207', 1300.00, 'assets/images/chatto_turf.jpg', 'https://www.google.com/maps/place/Chatto+Turf'),
(2, 'Courtside 100ft', 'All-weather turf with pro-level goal posts and lounge area.', 'Dhanmondi, Dhaka 1209', 1700.00, 'assets/images/courtside_100ft.jpg', 'https://www.google.com/maps/place/Courtside+100ft'),
(2, 'Dhaka Metroplex 300ft', 'Large sports complex with high-quality turf and training lights.', 'Mirpur Road, Dhaka 1216', 2200.00, 'assets/images/dhaka_metroplex_300ft.jpg', 'https://www.google.com/maps/place/Dhaka+Metroplex+300ft'),
(3, 'JAFF Sports Field', 'Popular Friday evening turf with great turf quality and booking support.', 'Banani, Dhaka 1213', 1800.00, 'assets/images/jaff_sports_field.jpg', 'https://www.google.com/maps/place/JAFF+Sports+Field'),
(3, 'Bashundhara Turf', 'Indoor-style field for crisp passes and competitive games.', 'Bashundhara R/A, Dhaka 1229', 2400.00, 'assets/images/bashundhara_turf.jpg', 'https://www.google.com/maps/place/Bashundhara+Turf'),
(4, 'Green Arena Mirpur', 'Premium venue close to Mirpur Stadium with modern amenities.', 'Mirpur 2, Dhaka 1216', 1950.00, 'assets/images/green_arena_mirpur.jpg', 'https://www.google.com/maps/place/Green+Arena+Mirpur'),
(4, 'Dhanmondi Football Turf', 'Compact and fast surface designed for 7-a-side action.', 'Dhanmondi Lake Rd, Dhaka 1205', 1400.00, 'assets/images/dhanmondi_football_turf.jpg', 'https://www.google.com/maps/place/Dhanmondi+Football+Turf'),
(5, 'Gulshan Elite Turf', 'Luxury turf venue with rooftop views and premium floodlighting.', 'Gulshan 2, Dhaka 1212', 2800.00, 'assets/images/gulshan_elite_turf.jpg', 'https://www.google.com/maps/place/Gulshan+Elite+Turf'),
(5, 'New Market Sports Turf', 'Local favorite turf with affordable rates and friendly booking service.', 'New Market, Dhaka 1205', 1200.00, 'assets/images/new_market_sports_turf.jpg', 'https://www.google.com/maps/place/New+Market+Sports+Turf');
