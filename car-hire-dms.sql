-- ============================================================
-- CAR HIRE SERVICE DATABASE MANAGEMENT SYSTEM
-- ============================================================
-- This database manages a complete car rental service including
-- customers, vehicles, bookings, payments, and maintenance records
-- ============================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS CarHireService;
USE CarHireService;

-- ============================================================
-- TABLE CREATION WITH CONSTRAINTS AND RELATIONSHIPS
-- ============================================================

-- 1. CUSTOMERS TABLE
-- Stores customer information for the car hire service
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    driving_license_number VARCHAR(50) UNIQUE NOT NULL,
    license_expiry_date DATE NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL DEFAULT 'Kenya',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')

);

-- 2. VEHICLE CATEGORIES TABLE
-- Defines different categories of vehicles (Economy, SUV, Luxury, etc.)
CREATE TABLE VehicleCategories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    daily_rate DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_daily_rate CHECK (daily_rate > 0)
);

-- 3. VEHICLES TABLE
-- Stores information about all vehicles in the fleet
CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year_manufactured YEAR NOT NULL,
    color VARCHAR(30) NOT NULL,
    fuel_type ENUM('Petrol', 'Diesel', 'Electric', 'Hybrid') NOT NULL,
    transmission ENUM('Manual', 'Automatic') NOT NULL,
    seating_capacity INT NOT NULL,
    mileage DECIMAL(8,2) DEFAULT 0,
    category_id INT NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_price DECIMAL(12,2) NOT NULL,
    current_status ENUM('Available', 'Rented', 'Maintenance', 'Out_of_Service') DEFAULT 'Available',
    last_service_date DATE,
    next_service_date DATE,
    insurance_expiry DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES VehicleCategories(category_id) ON DELETE RESTRICT,
    CONSTRAINT chk_year CHECK (year_manufactured >= 1990 AND year_manufactured <= 2025),
    CONSTRAINT chk_seating CHECK (seating_capacity BETWEEN 2 AND 12),
    CONSTRAINT chk_mileage CHECK (mileage >= 0),
    CONSTRAINT chk_purchase_price CHECK (purchase_price > 0)

);

-- 4. LOCATIONS TABLE
-- Stores pickup and drop-off locations
CREATE TABLE Locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    location_name VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    operating_hours VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. EMPLOYEES TABLE
-- Stores information about employees managing the car hire service
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    location_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id) ON DELETE SET NULL,
    CONSTRAINT chk_salary CHECK (salary > 0)

);

-- 6. BOOKINGS TABLE
-- Main table for car rental bookings
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_reference VARCHAR(20) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    pickup_location_id INT NOT NULL,
    dropoff_location_id INT NOT NULL,
    pickup_date DATETIME NOT NULL,
    expected_return_date DATETIME NOT NULL,
    actual_return_date DATETIME NULL,
    daily_rate DECIMAL(10,2) NOT NULL,
    total_days INT NOT NULL,
    base_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status ENUM('Confirmed', 'Active', 'Completed', 'Cancelled') DEFAULT 'Confirmed',
    payment_status ENUM('Pending', 'Paid', 'Partial', 'Refunded') DEFAULT 'Pending',
    created_by INT,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE RESTRICT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE RESTRICT,
    FOREIGN KEY (pickup_location_id) REFERENCES Locations(location_id) ON DELETE RESTRICT,
    FOREIGN KEY (dropoff_location_id) REFERENCES Locations(location_id) ON DELETE RESTRICT,
    FOREIGN KEY (created_by) REFERENCES Employees(employee_id) ON DELETE SET NULL,
    CONSTRAINT chk_dates CHECK (expected_return_date > pickup_date),
    CONSTRAINT chk_total_days CHECK (total_days > 0),
    CONSTRAINT chk_amounts CHECK (base_amount > 0 AND total_amount > 0 AND tax_amount >= 0),
    CONSTRAINT chk_discount CHECK (discount_amount >= 0 AND discount_amount <= base_amount)
);

-- 7. PAYMENTS TABLE
-- Tracks all payment transactions
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_reference VARCHAR(50) UNIQUE NOT NULL,
    payment_method ENUM('Cash', 'Card', 'Bank_Transfer', 'Mobile_Money') NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('Successful', 'Failed', 'Pending', 'Refunded') DEFAULT 'Successful',
    transaction_id VARCHAR(100),
    processed_by INT,
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE RESTRICT,
    FOREIGN KEY (processed_by) REFERENCES Employees(employee_id) ON DELETE SET NULL,
    CONSTRAINT chk_payment_amount CHECK (payment_amount > 0)
);

-- 8. VEHICLE MAINTENANCE TABLE
-- Tracks maintenance and repair records for vehicles
CREATE TABLE VehicleMaintenance (
    maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    maintenance_type ENUM('Regular_Service', 'Repair', 'Inspection', 'Oil_Change', 'Tire_Change', 'Other') NOT NULL,
    description TEXT NOT NULL,
    maintenance_date DATE NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    service_provider VARCHAR(100) NOT NULL,
    next_service_km DECIMAL(8,2),
    performed_by INT,
    status ENUM('Scheduled', 'In_Progress', 'Completed', 'Cancelled') DEFAULT 'Completed',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE RESTRICT,
    FOREIGN KEY (performed_by) REFERENCES Employees(employee_id) ON DELETE SET NULL,
    CONSTRAINT chk_maintenance_cost CHECK (cost >= 0)

);

-- 9. DAMAGE REPORTS TABLE
-- Records any damage to vehicles during rental period
CREATE TABLE DamageReports (
    damage_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    damage_description TEXT NOT NULL,
    damage_type ENUM('Minor', 'Major', 'Cosmetic', 'Mechanical') NOT NULL,
    damage_cost DECIMAL(10,2) NOT NULL,
    reported_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reported_by INT,
    repair_status ENUM('Pending', 'In_Progress', 'Completed', 'Not_Required') DEFAULT 'Pending',
    insurance_claim BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE RESTRICT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE RESTRICT,
    FOREIGN KEY (reported_by) REFERENCES Employees(employee_id) ON DELETE SET NULL,
    CONSTRAINT chk_damage_cost CHECK (damage_cost >= 0)
);

-- 10. CUSTOMER REVIEWS TABLE
-- Stores customer feedback and ratings
CREATE TABLE CustomerReviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    rating INT NOT NULL,
    review_title VARCHAR(100),
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_approved BOOLEAN DEFAULT FALSE,
    approved_by INT,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE RESTRICT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id) ON DELETE RESTRICT,
    FOREIGN KEY (approved_by) REFERENCES Employees(employee_id) ON DELETE SET NULL,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5)
);

-- ============================================================
-- INDEXES FOR BETTER PERFORMANCE
-- ============================================================

-- Indexes on frequently queried columns
CREATE INDEX idx_customers_email ON Customers(email);
CREATE INDEX idx_vehicles_registration ON Vehicles(registration_number);
CREATE INDEX idx_vehicles_status ON Vehicles(current_status);
CREATE INDEX idx_bookings_customer ON Bookings(customer_id);
CREATE INDEX idx_bookings_vehicle ON Bookings(vehicle_id);
CREATE INDEX idx_bookings_dates ON Bookings(pickup_date, expected_return_date);
CREATE INDEX idx_bookings_status ON Bookings(booking_status);
CREATE INDEX idx_payments_booking ON Payments(booking_id);
CREATE INDEX idx_maintenance_vehicle ON VehicleMaintenance(vehicle_id);
CREATE INDEX idx_maintenance_date ON VehicleMaintenance(maintenance_date);

-- ============================================================
-- TRIGGERS FOR BUSINESS LOGIC
-- ============================================================

-- Trigger to update vehicle status when booking is created
DELIMITER $$
CREATE TRIGGER trg_booking_vehicle_status
    AFTER UPDATE ON Bookings
    FOR EACH ROW
BEGIN
    IF NEW.booking_status = 'Active' AND OLD.booking_status = 'Confirmed' THEN
        UPDATE Vehicles SET current_status = 'Rented' WHERE vehicle_id = NEW.vehicle_id;
    ELSEIF NEW.booking_status = 'Completed' AND OLD.booking_status = 'Active' THEN
        UPDATE Vehicles SET current_status = 'Available' WHERE vehicle_id = NEW.vehicle_id;
    ELSEIF NEW.booking_status = 'Cancelled' THEN
        UPDATE Vehicles SET current_status = 'Available' WHERE vehicle_id = NEW.vehicle_id;
    END IF;
END$$
DELIMITER ;

-- Trigger to calculate total amount in bookings
DELIMITER $$
CREATE TRIGGER trg_calculate_booking_total
    BEFORE INSERT ON Bookings
    FOR EACH ROW
BEGIN
    SET NEW.base_amount = NEW.daily_rate * NEW.total_days;
    SET NEW.total_amount = NEW.base_amount - IFNULL(NEW.discount_amount, 0) + NEW.tax_amount;
END$$
DELIMITER ;

-- ============================================================
-- SAMPLE VIEWS FOR COMMON QUERIES
-- ============================================================

-- View for available vehicles with category details
CREATE VIEW AvailableVehicles AS
SELECT 
    v.vehicle_id,
    v.registration_number,
    v.make,
    v.model,
    v.year_manufactured,
    v.color,
    v.fuel_type,
    v.transmission,
    v.seating_capacity,
    vc.category_name,
    vc.daily_rate,
    v.current_status
FROM Vehicles v
JOIN VehicleCategories vc ON v.category_id = vc.category_id
WHERE v.current_status = 'Available' AND v.is_active = TRUE;

-- View for booking summary with customer and vehicle details
CREATE VIEW BookingSummary AS
SELECT 
    b.booking_id,
    b.booking_reference,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS customer_email,
    c.phone AS customer_phone,
    CONCAT(v.make, ' ', v.model, ' (', v.registration_number, ')') AS vehicle_details,
    pl.location_name AS pickup_location,
    dl.location_name AS dropoff_location,
    b.pickup_date,
    b.expected_return_date,
    b.total_amount,
    b.booking_status,
    b.payment_status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
JOIN Locations pl ON b.pickup_location_id = pl.location_id
JOIN Locations dl ON b.dropoff_location_id = dl.location_id;

-- View for payment summary
CREATE VIEW PaymentSummary AS
SELECT 
    p.payment_id,
    p.payment_reference,
    b.booking_reference,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.payment_amount,
    p.payment_method,
    p.payment_date,
    p.payment_status
FROM Payments p
JOIN Bookings b ON p.booking_id = b.booking_id
JOIN Customers c ON b.customer_id = c.customer_id;

-- View for vehicle maintenance history
CREATE VIEW MaintenanceHistory AS
SELECT 
    vm.maintenance_id,
    v.registration_number,
    CONCAT(v.make, ' ', v.model) AS vehicle_info,
    vm.maintenance_type,
    vm.description,
    vm.maintenance_date,
    vm.cost,
    vm.service_provider,
    vm.status
FROM VehicleMaintenance vm
JOIN Vehicles v ON vm.vehicle_id = v.vehicle_id;

-- ============================================================
-- STORED PROCEDURES FOR COMMON OPERATIONS
-- ============================================================

-- Procedure to create a new booking
DELIMITER $$
CREATE PROCEDURE CreateBooking(
    IN p_customer_id INT,
    IN p_vehicle_id INT,
    IN p_pickup_location_id INT,
    IN p_dropoff_location_id INT,
    IN p_pickup_date DATETIME,
    IN p_expected_return_date DATETIME,
    IN p_created_by INT
)
BEGIN
    DECLARE v_daily_rate DECIMAL(10,2);
    DECLARE v_total_days INT;
    DECLARE v_booking_ref VARCHAR(20);
    DECLARE v_tax_rate DECIMAL(4,2) DEFAULT 0.16; -- 16% VAT
    
    -- Generate booking reference
    SET v_booking_ref = CONCAT('BK', LPAD(FLOOR(RAND() * 999999), 6, '0'));
    
    -- Get daily rate for the vehicle
    SELECT vc.daily_rate INTO v_daily_rate
    FROM Vehicles v
    JOIN VehicleCategories vc ON v.category_id = vc.category_id
    WHERE v.vehicle_id = p_vehicle_id;
    
    -- Calculate total days
    SET v_total_days = DATEDIFF(p_expected_return_date, p_pickup_date);
    
    -- Insert booking
    INSERT INTO Bookings (
        booking_reference, customer_id, vehicle_id, pickup_location_id, 
        dropoff_location_id, pickup_date, expected_return_date, daily_rate, 
        total_days, tax_amount, created_by
    ) VALUES (
        v_booking_ref, p_customer_id, p_vehicle_id, p_pickup_location_id,
        p_dropoff_location_id, p_pickup_date, p_expected_return_date, 
        v_daily_rate, v_total_days, (v_daily_rate * v_total_days * v_tax_rate), 
        p_created_by
    );
    
    -- Update vehicle status to reserved
    UPDATE Vehicles SET current_status = 'Rented' WHERE vehicle_id = p_vehicle_id;
    
    SELECT LAST_INSERT_ID() as booking_id, v_booking_ref as booking_reference;
    
END$$
DELIMITER ;

-- ============================================================
-- DATABASE SETUP COMPLETE
-- ============================================================

-- Display success message
SELECT 'Car Hire Service Database Management System Created Successfully!' AS Status;
SELECT 'Database includes 10 tables with proper relationships, constraints, indexes, triggers, views, and stored procedures.' AS Details;