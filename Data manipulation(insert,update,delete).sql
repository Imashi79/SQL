-- Insert --
INSERT INTO Category (name) VALUES ('Gardening');

-- Creating table with a default value for columns --
CREATE TABLE Users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active' -- default value --
);

-- Insert a new row without providing a status value --
INSERT INTO Users (id, name) VALUES (1, 'Anne'); -- 'status' defaults to 'active'

-- Update -- 
-- Update a single column --
UPDATE Users 
SET status = 'disable'  
WHERE id = 1;

-- Update multiple columns --
UPDATE Products 
SET price = 700, category_id = 2  
WHERE product_id = 2;

-- Add a new column --
ALTER TABLE Users 
ADD email VARCHAR(60);

-- Delete --

-- Delete a specific row --
DELETE FROM Users 
WHERE id = 1;

-- Delete all the records --
--DELETE: Allows conditional row deletion using the WHERE clause.--
DELETE FROM Users;

-- Or truncate the table to remove all rows --
--TRUNCATE TABLE: Removes all rows quickly but cannot be used with a WHERE clause.--
TRUNCATE TABLE Users;

-- Drop/remove a column --
ALTER TABLE Users 
DROP COLUMN email;

-- Drop/remove the entire table --
DROP TABLE Users;
