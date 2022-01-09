-- Some fraudsters hack a credit card by making several small transactions (generally less than $2.00), which are typically ignored by cardholders.

-- How can you isolate (or group) the transactions of each cardholder?
CREATE VIEW "Transactions by Card Holder" AS
SELECT ch.name, t.*
FROM card_holder AS ch
INNER JOIN credit_card AS cc ON ch.id = cc.id_cardholder
INNER JOIN transaction AS t ON cc.card = t.card
WHERE t.amount < 2
ORDER BY ch.name;

-- Count the transactions that are less than $2.00 per cardholder.
CREATE VIEW "Cardholder Transactions less than $2" AS
SELECT ch.name, COUNT(*) AS dubious_transaction_count
FROM card_holder AS ch
INNER JOIN credit_card AS cc ON ch.id = cc.id_cardholder
INNER JOIN transaction AS t ON cc.card = t.card
WHERE t.amount < 2
GROUP BY ch.name
ORDER BY dubious_transaction_count DESC;

-- Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
-- Get the number of transactions less than $2 per card, rather than cardholder
CREATE VIEW "Card Transactions less than $2" AS
SELECT t.card, COUNT(*) AS dubious_transaction_count
FROM transaction AS t
WHERE t.amount < 2
GROUP BY t.card
ORDER BY dubious_transaction_count DESC;
-- Get average days between suspicious transactions for each card
CREATE VIEW "Average Days Between Suspicious Transactions Per Card" AS
SELECT t.card, (MAX(t.date) - MIN(t.date)) AS date_range, COUNT(*) AS dubious_transaction_count, (MAX(t.date) - MIN(t.date))/COUNT(*) AS avg_days_between_suspicious_tx
FROM transaction as t
WHERE t.amount < 2
GROUP BY t.card
ORDER BY avg_days_between_suspicious_tx;

-- Take your investigation a step futher by considering the time period in which potentially fraudulent transactions are made.

-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
CREATE VIEW "Top 100 Highest Transactions Made Between 7:00 am And 9:00 am" AS
SELECT *
FROM transaction AS t
WHERE CAST(t.date AS TIME) BETWEEN '07:00' and '09:00'
ORDER BY t.amount DESC
LIMIT 100;

CREATE VIEW "Suspicious Transactions Made Between 7:00 am And 9:00 am" AS
SELECT t.card, COUNT(*)
FROM transaction AS t
WHERE t.amount < 2 AND CAST(t.date AS TIME) BETWEEN '07:00' and '09:00'
GROUP BY t.card;

-- Do you see any anomalous transactions that could be fraudulent?
-- There are only 8 transactions that have amounts greater tahn $500.
-- While some may be suspect these to be fraudulent, it may be the case that the cardholder was shopping online in these early hours,
-- or perhaps were in a different time zone to what is recorded in the transaction.
-- I consider the data here insufficient and the results inconclusive.

-- Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
-- Rest of the day i.e. before 7am and after 9am
CREATE VIEW "Top 100 Highest Transactions Made Before 7am And After 9am" AS
SELECT *
FROM transaction AS t
WHERE CAST(t.date AS TIME) < '07:00' or CAST(t.date AS TIME) > '09:00'
ORDER BY t.amount DESC
LIMIT 100;
-- The rest of the day has a higher number of larger transactions.
CREATE VIEW "Suspicious Transactions Made Before 7am And After 9am" AS
SELECT t.card, COUNT(*)
FROM transaction AS t
WHERE t.amount < 2 AND (
	CAST(t.date AS TIME) < '07:00' OR
	CAST(t.date AS TIME) > '09:00'
)
GROUP BY t.card;
-- The rest of the day (before 7am and after 9am) has a higher number of transactions less than $2.

-- If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.

-- What are the top 5 merchants prone to being hacked using small transactions?
CREATE VIEW "Top Hacked Merchants" AS
SELECT m.name as merchant_name, COUNT(*) AS dubious_transaction_count
FROM card_holder AS ch
INNER JOIN credit_card AS cc ON ch.id = cc.id_cardholder
INNER JOIN transaction AS t ON cc.card = t.card
INNER JOIN merchant as m ON t.id_merchant = m.id
WHERE t.amount < 2
GROUP BY m.name
ORDER BY dubious_transaction_count DESC;
-- There are 3 merchants which recorded 6 or more transactions of less than $2
-- Wood-Ramirez recorded 7, while Hood-Phillips and Baker Inc both recorded 6.
-- After these, there are 12 other merchants which record 5 such transactions:
-- "Riggs-Adams"
-- "Reed Group"
-- "Martinez Group"
-- "Walker, Deleon and Wolf"
-- "Greene-Wood"
-- "Jarvis-Turner"
-- "Mcdaniel, Hines and Mcfarland"
-- "Hamilton-Mcfarland"
-- "Atkinson Ltd"
-- "Clark and Sons"
-- "Henderson and Sons"
-- "Sweeney-Paul"
