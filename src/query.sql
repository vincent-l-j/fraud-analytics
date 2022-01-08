-- Some fraudsters hack a credit card by making several small transactions (generally less than $2.00), which are typically ignored by cardholders.

-- How can you isolate (or group) the transactions of each cardholder?
SELECT ch.name, t.*
FROM card_holder AS ch
INNER JOIN credit_card AS cc ON ch.id = cc.id_cardholder
INNER JOIN transaction AS t ON cc.card = t.card
WHERE t.amount < 2
ORDER BY ch.name;

-- Count the transactions that are less than $2.00 per cardholder.
SELECT ch.name, COUNT(*) AS dubious_transaction_count
FROM card_holder AS ch
INNER JOIN credit_card AS cc ON ch.id = cc.id_cardholder
INNER JOIN transaction AS t ON cc.card = t.card
WHERE t.amount < 2
GROUP BY ch.name
ORDER BY dubious_transaction_count DESC;

-- Is there any evidence to suggest that a credit card has been hacked? Explain your rationale.
-- Get the number of transactions less than $2 per card, rather than cardholder
SELECT t.card, COUNT(*) AS dubious_transaction_count
FROM transaction AS t
WHERE t.amount < 2
GROUP BY t.card
ORDER BY dubious_transaction_count DESC;
-- Get average days between suspicious transactions for each card
SELECT t.card, (MAX(t.date) - MIN(t.date)) AS date_range, COUNT(*) AS dubious_transaction_count, (MAX(t.date) - MIN(t.date))/COUNT(*) AS avg_days_between_suspicious_tx
FROM transaction as t
WHERE t.amount < 2
GROUP BY t.card
ORDER BY avg_days_between_suspicious_tx;

-- Take your investigation a step futher by considering the time period in which potentially fraudulent transactions are made.

-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT *
FROM transaction AS t
WHERE CAST(t.date AS TIME) BETWEEN '07:00' and '09:00'
ORDER BY t.amount DESC
LIMIT 100;


-- Do you see any anomalous transactions that could be fraudulent?
-- There are only 8 transactions that have amounts greater tahn $500.
-- While some may be suspect these to be fraudulent, it may be the case that the cardholder was shopping online in these early hours,
-- or perhaps were in a different time zone to what is recorded in the transaction.
-- I consider the data here insufficient and the results inconclusive.

-- Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
-- Rest of the day i.e. before 7am and after 9am
SELECT *
FROM transaction AS t
WHERE CAST(t.date AS TIME) < '07:00' or CAST(t.date AS TIME) > '09:00'
ORDER BY t.amount DESC
LIMIT 100;

-- If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.
