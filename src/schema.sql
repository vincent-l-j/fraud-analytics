DROP TABLE IF EXISTS card_holder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;

-- Create card_holder table
CREATE TABLE card_holder (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(255)
);

-- Create credit card table
CREATE TABLE credit_card (
  card VARCHAR(20) NOT NULL PRIMARY KEY,
  id_cardholder INT NOT NULL,
  FOREIGN KEY (id_cardholder) REFERENCES card_holder(id)
);

-- Create merchant_category table
CREATE TABLE merchant_category (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(50)
);

-- Create merchant table
CREATE TABLE merchant (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  id_merchant_category INT NOT NULL,
  FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

-- Create transaction table
CREATE TABLE transaction (
  id INT NOT NULL PRIMARY KEY,
  date TIMESTAMP NOT NULL,
  amount FLOAT,
  card VARCHAR(20) NOT NULL,
  FOREIGN KEY (card) REFERENCES credit_card(card),
  id_merchant INT NOT NULL,
  FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);
