# Car Hire Service Database Management System

A comprehensive MySQL database system designed to manage all aspects of a car rental business, including customer management, vehicle fleet operations, bookings, payments, maintenance tracking, and customer reviews.

## Database Overview

This database management system provides a complete solution for car hire/rental services with proper normalization, constraints, relationships, and business logic implementation. The system is designed to handle the complex operations of a modern car rental business while maintaining data integrity and performance.

## Database Structure

### Core Tables (10 Tables)

1. **Customers** - Customer information and driving credentials
2. **VehicleCategories** - Vehicle classification and pricing tiers
3. **Vehicles** - Complete vehicle fleet management
4. **Locations** - Pickup/dropoff locations and branches
5. **Employees** - Staff management and access control
6. **Bookings** - Main rental transaction records
7. **Payments** - Payment processing and financial tracking
8. **VehicleMaintenance** - Vehicle service and repair history
9. **DamageReports** - Incident tracking and insurance claims
10. **CustomerReviews** - Customer feedback and rating system

### Key Features

#### Data Integrity & Constraints
- Primary and foreign key relationships with proper cascading
- Check constraints for business rule enforcement
- Unique constraints to prevent data duplication
- Proper data types with appropriate sizes
- NOT NULL constraints for required fields

#### Advanced Database Features
- **Indexes** on frequently queried columns for performance optimization
- **Triggers** for automatic business logic execution
- **Views** for simplified data access and reporting
- **Stored Procedures** for complex operations
- **ENUM types** for controlled data entry

## Table Specifications

### 1. Customers
Stores comprehensive customer information including:
- Personal details (name, contact, address)
- Driving license information and expiry tracking
- Registration date and account status
- Email validation constraint
- Unique license number enforcement

### 2. VehicleCategories
Defines rental categories with:
- Category names (Economy, SUV, Luxury, etc.)
- Daily rental rates
- Category descriptions
- Rate validation constraints

### 3. Vehicles
Complete vehicle fleet management:
- Registration and identification details
- Make, model, year, and specifications
- Fuel type and transmission options
- Current status tracking (Available, Rented, Maintenance)
- Service scheduling and insurance tracking
- Mileage and condition monitoring

### 4. Locations
Branch and location management:
- Location names and addresses
- Contact information and operating hours
- Active status tracking

### 5. Employees
Staff management system:
- Employee codes and personal information
- Position and salary tracking
- Location assignment
- Hire date and status management

### 6. Bookings (Core Transaction Table)
Comprehensive booking management:
- Unique booking reference generation
- Customer and vehicle associations
- Pickup/dropoff locations and dates
- Rate calculations and pricing
- Status tracking (Confirmed, Active, Completed, Cancelled)
- Payment status monitoring
- Automatic total calculation via triggers

### 7. Payments
Financial transaction tracking:
- Payment method support (Cash, Card, Bank Transfer, Mobile Money)
- Payment reference and transaction ID tracking
- Multiple payment status options
- Staff processing records
- Amount validation constraints

### 8. VehicleMaintenance
Vehicle service management:
- Maintenance type classification
- Cost tracking and service provider records
- Next service scheduling
- Status monitoring (Scheduled, In Progress, Completed)
- Staff assignment for maintenance tasks

### 9. DamageReports
Incident and damage tracking:
- Damage type classification (Minor, Major, Cosmetic, Mechanical)
- Cost assessment and repair status
- Insurance claim tracking
- Staff reporting records

### 10. CustomerReviews
Customer feedback system:
- 1-5 star rating system
- Review titles and detailed feedback
- Approval workflow for published reviews
- Staff moderation capabilities

## Database Views

### AvailableVehicles
Displays all available vehicles with:
- Complete vehicle specifications
- Category and pricing information
- Current availability status

### BookingSummary
Comprehensive booking overview with:
- Customer details and contact information
- Vehicle specifications
- Location and date information
- Financial summary and status

### PaymentSummary
Payment transaction overview:
- Payment references and amounts
- Customer and booking associations
- Payment methods and status tracking

### MaintenanceHistory
Vehicle service tracking:
- Complete maintenance records
- Vehicle identification and details
- Service costs and provider information
- Maintenance status and scheduling

## Stored Procedures

### CreateBooking
Automated booking creation procedure that:
- Generates unique booking references
- Calculates total days and pricing
- Applies tax calculations (16% VAT)
- Updates vehicle availability status
- Returns booking confirmation details

## Business Logic Implementation

### Triggers

#### trg_booking_vehicle_status
Automatically updates vehicle status based on booking changes:
- Sets vehicles to 'Rented' when bookings become active
- Returns vehicles to 'Available' when bookings complete
- Handles cancellation status updates

#### trg_calculate_booking_total
Automatic financial calculations:
- Calculates base amounts from daily rates
- Applies discounts and tax calculations
- Ensures accurate total amount computation

### Constraints and Validations

- **Email Validation**: Ensures proper email format
- **Date Validation**: Prevents invalid date ranges
- **Financial Validation**: Ensures positive amounts and logical calculations
- **Rating Validation**: Restricts reviews to 1-5 star ratings
- **Status Validation**: Enforces proper status transitions

## Performance Optimization

### Indexes Created
- Customer email lookup
- Vehicle registration and status
- Booking customer and vehicle associations
- Date range queries for availability
- Payment and maintenance tracking

These indexes significantly improve query performance for common operations like vehicle searches, customer lookups, and booking management.

## Setup Instructions

### Prerequisites
- MySQL Server 5.7+ or MariaDB 10.2+
- Database administration access
- Sufficient storage space for expected data volume

### Installation Steps

1. **Connect to MySQL Server**
   ```sql
   mysql -u root -p
   ```

2. **Execute the Database Script**
   ```sql
   SOURCE car_hire_service.sql;
   ```

3. **Verify Installation**
   ```sql
   USE CarHireService;
   SHOW TABLES;
   ```

4. **Test Basic Functionality**
   ```sql
   SELECT * FROM AvailableVehicles LIMIT 5;
   ```

## Usage Examples

### Adding Sample Data
```sql
-- Add vehicle categories
INSERT INTO VehicleCategories (category_name, daily_rate, description) 
VALUES ('Economy', 25.00, 'Budget-friendly vehicles for city driving');

-- Add locations
INSERT INTO Locations (location_name, address, city, phone, operating_hours) 
VALUES ('Downtown Branch', '123 Main St', 'Nairobi', '+254-123-4567', '8AM-8PM');

-- Add vehicles
INSERT INTO Vehicles (registration_number, make, model, year_manufactured, color, fuel_type, transmission, seating_capacity, category_id, purchase_date, purchase_price, insurance_expiry) 
VALUES ('KCA-123A', 'Toyota', 'Corolla', 2022, 'White', 'Petrol', 'Automatic', 5, 1, '2022-01-15', 2500000, '2025-01-15');
```

### Common Queries
```sql
-- Find available vehicles in a specific category
SELECT * FROM AvailableVehicles WHERE category_name = 'Economy';

-- Get customer booking history
SELECT * FROM BookingSummary WHERE customer_email = 'customer@example.com';

-- Check vehicle maintenance due
SELECT * FROM Vehicles WHERE next_service_date <= CURDATE();
```

## Security Considerations

### Access Control
- Use role-based access with limited privileges
- Separate read-only accounts for reporting
- Restricted access to financial data

### Data Protection
- Encrypt sensitive customer information
- Regular backup procedures
- Audit trail implementation
- Secure connection requirements

## Maintenance and Monitoring

### Regular Tasks
- **Daily**: Monitor booking status and payment processing
- **Weekly**: Review maintenance schedules and vehicle availability
- **Monthly**: Analyze customer reviews and service quality
- **Quarterly**: Database performance optimization and cleanup

### Monitoring Points
- Vehicle utilization rates
- Payment processing success rates
- Maintenance cost tracking
- Customer satisfaction metrics

## Reporting Capabilities

The database supports various business reports:
- Revenue analysis by vehicle category
- Customer activity and loyalty tracking
- Vehicle utilization and maintenance costs
- Location performance metrics
- Damage incident analysis

## Scalability Considerations

### Growth Planning
- Partitioning strategies for large booking tables
- Archiving strategies for historical data
- Read replica setup for reporting workloads
- Caching strategies for frequently accessed data

### Performance Monitoring
- Query performance analysis
- Index usage optimization
- Connection pool management
- Resource utilization tracking

## Integration Points

The database is designed to integrate with:
- Web-based booking systems
- Mobile applications
- Payment gateways
- Fleet management systems
- Customer relationship management (CRM) tools
- Business intelligence and reporting platforms

## Support and Documentation

### Database Schema
Complete entity relationship diagrams and table specifications are available in the database comments and constraints.

### Business Rules
All business logic is documented within stored procedures, triggers, and constraint definitions.

### API Integration
The database structure supports REST API development with clear entity relationships and standardized naming conventions.

## Version History

- **v1.0**: Initial database structure with core functionality
- Includes all essential tables, relationships, and business logic
- Production-ready with proper constraints and optimization

This database management system provides a solid foundation for car hire service operations with room for customization and expansion based on specific business requirements.
