-- MySQL schema for the KhelaHobe ecosystem
-- Tables: users, venues, investments

CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `role` ENUM('player','landowner','investor') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_users_email` (`email`),
  KEY `idx_users_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `venues` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `landowner_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `type` ENUM('turf','picnic_area') NOT NULL,
  `location` VARCHAR(300) NOT NULL,
  `description` TEXT,
  `price_per_hour` DECIMAL(10,2) NOT NULL,
  `image_url` VARCHAR(500) DEFAULT NULL,
  `map_link` VARCHAR(500) DEFAULT NULL,
  `capacity` INT UNSIGNED DEFAULT NULL,
  `available` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_venues_landowner_id` (`landowner_id`),
  KEY `idx_venues_type` (`type`),
  CONSTRAINT `fk_venues_landowner`
    FOREIGN KEY (`landowner_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `investments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `investor_id` BIGINT UNSIGNED NOT NULL,
  `venue_id` BIGINT UNSIGNED NOT NULL,
  `capital_amount` DECIMAL(14,2) NOT NULL,
  `roi_percentage` DECIMAL(5,2) NOT NULL,
  `investment_date` DATE NOT NULL,
  `maturity_date` DATE DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_investments_investor_id` (`investor_id`),
  KEY `idx_investments_venue_id` (`venue_id`),
  CONSTRAINT `fk_investments_investor`
    FOREIGN KEY (`investor_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_investments_venue`
    FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `venues` (
  `landowner_id`, `name`, `type`, `location`, `description`, `price_per_hour`, `image_url`, `map_link`, `capacity`, `available`
) VALUES
  (1, 'ALPHA Sports Mohammadpur', 'turf', 'Mohammadpur, Dhaka', 'Premium football turf in Mohammadpur with modern facilities.', 1200, 'assets/images/ALPHA Sports- Mohammadpur.jpg', 'https://maps.google.com/?q=ALPHA+Sports+Mohammadpur+Dhaka', 12, 1),
  (1, 'Chatto Turf', 'turf', '2 No. Gate More, Chattogram', 'Popular turf in Chattogram with fast booking availability.', 1600, 'assets/images/chato turf.jpg', 'https://maps.google.com/?q=Chatto+Turf', 10, 1),
  (1, 'Courtside 100ft', 'turf', '100ft Madani Avenue, Dhaka', 'Spacious 100ft court with excellent surface quality.', 2500, 'assets/images/Courtside 100ft.jpg', 'https://maps.google.com/?q=Courtside+Madani+Avenue+Dhaka', 14, 1),
  (1, 'Dhaka Metroplex 300ft', 'turf', '300ft Road, Dhaka', 'Large turf for training and match play in Dhaka.', 3500, 'assets/images/Dhaka Metroplex 300ft.jpg', 'https://maps.google.com/?q=Dhaka+Metroplex+300ft', 16, 1),
  (1, 'DSF Dhanmondi', 'turf', 'Dhanmondi, Dhaka', 'High-quality turf facility in a central Dhaka location.', 1500, 'assets/images/DSF Dhanmondi.jpg', 'https://maps.google.com/?q=DSF+Dhanmondi', 12, 1),
  (1, 'JAFF', 'turf', 'Bashundhara R/A, Dhaka', 'Elite turf experience with modern amenities.', 3000, 'assets/images/JAFF.jpg', 'https://maps.google.com/?q=JAFF+Arena+Bashundhara+Dhaka', 18, 1),
  (1, 'NDE Futsal Field', 'turf', 'Bashundhara R/A, Dhaka', 'Great option for futsal and casual football sessions.', 2000, 'assets/images/NDE Futsal Field.jpg', 'https://maps.google.com/?q=NDE+Sports+Facility+Bashundhara', 10, 1),
  (1, 'Sports Grill', 'turf', 'Tejgaon, Dhaka', 'Premium venue with a lively sports atmosphere.', 3500, 'assets/images/sports grill.jpg', 'https://maps.google.com/?q=Sports+Grill+Tejgaon+Dhaka', 14, 1),
  (1, 'The Stadium', 'turf', 'Bashundhara R/A, Dhaka', 'Well-known turf for competitive play and training.', 3000, 'assets/images/stadium.jpg', 'https://maps.google.com/?q=The+Stadium+Bashundhara+Dhaka', 20, 1),
  (1, 'Turf Ground Uttara', 'turf', 'Sector 4, Uttara, Dhaka', 'Wide turf facility with easy access in Uttara.', 5300, 'assets/images/Turf Ground Uttara.jpg', 'https://maps.google.com/?q=Turf+Ground+Uttara+Dhaka', 15, 1);
