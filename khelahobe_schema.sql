-- ============================================================================
-- KhelaHobe! Sports Venue & Investment Platform - MySQL Database Schema
-- ============================================================================

-- Set the character set and collation
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ============================================================================
-- 1. USERS TABLE - Stores all user accounts
-- ============================================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('Admin', 'Player', 'Landowner', 'Investor') NOT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 2. VENUES TABLE - Stores venue information created by landowners
-- ============================================================================
CREATE TABLE venues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    landowner_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location_type ENUM('turf', 'indoor', 'picnic') NOT NULL,
    address VARCHAR(500) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    hourly_rate DECIMAL(10, 2) NOT NULL,
    capacity INT,
    status ENUM('pending', 'under_construction', 'active', 'inactive') NOT NULL DEFAULT 'pending',
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (landowner_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_landowner_id (landowner_id),
    INDEX idx_status (status),
    INDEX idx_location_type (location_type),
    INDEX idx_city (city),
    INDEX idx_created_at (created_at),
    INDEX idx_coordinates (latitude, longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 3. VENUE_AMENITIES TABLE - Additional amenities at venues
-- ============================================================================
CREATE TABLE venue_amenities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    amenity VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE CASCADE,
    INDEX idx_venue_id (venue_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 4. INVESTMENT_PROJECTS TABLE - Investment opportunities for venues
-- ============================================================================
CREATE TABLE investment_projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_amount DECIMAL(12, 2) NOT NULL,
    raised_amount DECIMAL(12, 2) DEFAULT 0,
    min_investment DECIMAL(10, 2) NOT NULL,
    max_investment DECIMAL(12, 2),
    expected_roi_percentage DECIMAL(5, 2),
    status ENUM('funding', 'funded', 'completed', 'cancelled') NOT NULL DEFAULT 'funding',
    funding_deadline DATE,
    completion_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE RESTRICT,
    INDEX idx_venue_id (venue_id),
    INDEX idx_status (status),
    INDEX idx_funding_deadline (funding_deadline),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 5. INVESTMENTS TABLE - Individual investment records
-- ============================================================================
CREATE TABLE investments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    investor_id INT NOT NULL,
    project_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    share_percentage DECIMAL(10, 4) NOT NULL,
    status ENUM('active', 'withdrawn', 'completed') NOT NULL DEFAULT 'active',
    invested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    withdrawn_at TIMESTAMP NULL,
    
    FOREIGN KEY (investor_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (project_id) REFERENCES investment_projects(id) ON DELETE RESTRICT,
    INDEX idx_investor_id (investor_id),
    INDEX idx_project_id (project_id),
    INDEX idx_status (status),
    INDEX idx_invested_at (invested_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 6. BOOKINGS TABLE - Venue bookings by players
-- ============================================================================
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    venue_id INT NOT NULL,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (player_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE RESTRICT,
    INDEX idx_player_id (player_id),
    INDEX idx_venue_id (venue_id),
    INDEX idx_booking_date (booking_date),
    INDEX idx_status (status),
    INDEX idx_venue_booking (venue_id, booking_date),
    UNIQUE KEY unique_venue_booking (venue_id, booking_date, start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 7. WALLETS TABLE - User financial wallets for payments and earnings
-- ============================================================================
CREATE TABLE wallets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    balance DECIMAL(12, 2) NOT NULL DEFAULT 0,
    total_earned DECIMAL(12, 2) DEFAULT 0,
    total_spent DECIMAL(12, 2) DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 8. TRANSACTIONS TABLE - Financial transaction history
-- ============================================================================
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    wallet_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'booking_payment', 'investment', 'refund', 'earnings') NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    description VARCHAR(500),
    reference_id INT,
    reference_table VARCHAR(50),
    status ENUM('pending', 'completed', 'failed', 'cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (wallet_id) REFERENCES wallets(id) ON DELETE RESTRICT,
    INDEX idx_wallet_id (wallet_id),
    INDEX idx_transaction_type (transaction_type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 9. REVIEWS TABLE - Reviews for venues by players
-- ============================================================================
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    venue_id INT NOT NULL,
    booking_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (player_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (venue_id) REFERENCES venues(id) ON DELETE RESTRICT,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE SET NULL,
    INDEX idx_venue_id (venue_id),
    INDEX idx_player_id (player_id),
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at),
    UNIQUE KEY unique_review (player_id, venue_id, booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 10. NOTIFICATIONS TABLE - User notifications
-- ============================================================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    related_entity_id INT,
    related_entity_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 11. AUDIT_LOGS TABLE - System audit trail
-- ============================================================================
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255) NOT NULL,
    entity_type VARCHAR(100),
    entity_id INT,
    old_values JSON,
    new_values JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_entity_type (entity_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================

-- Insert sample admin user
INSERT INTO users (name, email, password_hash, phone, role, is_verified, is_active) 
VALUES ('Admin User', 'admin@khelahobe.com', 'hashed_password_here', '+91-9999999999', 'Admin', TRUE, TRUE);

-- Insert sample landowner
INSERT INTO users (name, email, password_hash, phone, role, is_verified, is_active) 
VALUES ('Rajesh Kumar', 'rajesh@khelahobe.com', 'hashed_password_here', '+91-9876543210', 'Landowner', TRUE, TRUE);

-- Insert sample player
INSERT INTO users (name, email, password_hash, phone, role, is_verified, is_active) 
VALUES ('Amit Singh', 'amit@khelahobe.com', 'hashed_password_here', '+91-9123456789', 'Player', TRUE, TRUE);

-- Insert sample investor
INSERT INTO users (name, email, password_hash, phone, role, is_verified, is_active) 
VALUES ('Priya Patel', 'priya@khelahobe.com', 'hashed_password_here', '+91-9111111111', 'Investor', TRUE, TRUE);

-- Insert wallets for all users
INSERT INTO wallets (user_id, balance, total_earned, total_spent) 
VALUES (1, 10000.00, 0, 0), (2, 50000.00, 0, 0), (3, 5000.00, 0, 0), (4, 100000.00, 0, 0);

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
