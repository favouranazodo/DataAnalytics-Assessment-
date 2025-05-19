/*-- STEP 1: For each customer (owner_id), calculate:
--   - The average number of transactions per month by dividing:
--     total distinct transaction references / total distinct months with activity
--   - Use a CASE statement to classify the customer based on this average:
--       • 'High Frequency'   if average ≥ 10
--       • 'Medium Frequency' if average between 3 and 9
--       • 'Low Frequency'    if average ≤ 2
--   - This is done in the subquery (aliased as t1)

-- STEP 2: In the outer query, group the results by frequency category
--   - Count how many customers fall into each category (customer_count)
--   - Calculate the average number of transactions per month within each group
--   - Round this average to 1 decimal place for readability

-- STEP 3: Order the results by average transaction volume in descending order
--   - This helps prioritize the most engaged customer groups*/


SELECT
		t1.frequency_category, 
        COUNT(*) AS customer_count,
        ROUND(AVG(t1.average_transaction), 1) AS avg_transactions_per_month
FROM (
	SELECT 
    owner_id,
    ROUND(COUNT(DISTINCT transaction_reference)/COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')),0) AS average_transaction,
    CASE
        WHEN COUNT(DISTINCT transaction_reference) / COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) >= 10 THEN 'High Frequency'
        WHEN COUNT(DISTINCT transaction_reference) / COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
from savings_savingsaccount
group by 1)t1
Group by 1
ORDER BY avg_transactions_per_month DESC;
