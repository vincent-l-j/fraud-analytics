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
