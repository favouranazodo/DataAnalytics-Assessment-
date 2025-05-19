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