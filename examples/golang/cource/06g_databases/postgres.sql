CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    rank VARCHAR(255)
);

CREATE UNIQUE INDEX users_id_uindex ON cars(id);

CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    user_id INT,
    colour VARCHAR(255),
    brand VARCHAR(255),
    license_plate VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE UNIQUE INDEX cars_id_uindex ON cars(id);

INSERT INTO users (name, rank) VALUES
('Alice Johnson', 'Manager'),
('Bob Smith', 'Developer'),
('Charlie Brown', 'Designer'),
('Diana Prince', 'Marketing Specialist'),
('Ethan Hunt', 'Sales Representative'),
('Fiona Apple', 'HR Specialist'),
('George Lucas', 'Project Manager'),
('Hannah Montana', 'Data Analyst'),
('Ian Malcolm', 'Customer Support'),
('Jane Doe', 'Finance Officer');

INSERT INTO cars (user_id, colour, brand, license_plate) VALUES
(1, 'Red', 'Toyota', 'A1B2C3'),
(1, 'Yellow', 'Mercedes', 'S9T0U1'),
(2, 'Blue', 'Honda', 'D4E5F6'),
(2, 'Purple', 'Audi', 'V2W3X4'),
(3, 'Green', 'Ford', 'G7H8I9'),
(3, 'Orange', 'Volkswagen', 'Y5Z6A7'),
(4, 'Black', 'Chevrolet', 'J0K1L2'),
(4, 'Pink', 'Hyundai', 'B8C9D0'),
(5, 'White', 'Nissan', 'M3N4O5'),
(5, 'Brown', 'Kia', 'E1F2G3'),
(6, 'Silver', 'BMW', 'P6Q7R8'),
(6, 'Gray', 'Subaru', 'H4I5J6'),
(7, 'Red', 'Porsche', 'K7L8M9'),
(8, 'Blue', 'Tesla', 'N0O1P2'),
(9, 'Green', 'Mazda', 'Q3R4S5');


