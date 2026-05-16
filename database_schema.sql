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
