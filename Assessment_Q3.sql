WITH transactions AS (
    SELECT 
        id AS plan_id,
        owner_id, 
        DATE(MAX(transaction_date)) AS last_transaction_date,
        'savings' AS type
    FROM savings_savingsaccount
    WHERE new_balance > 0
    GROUP BY id, owner_id

    UNION ALL

    SELECT 
        id AS plan_id,
        owner_id, 
        DATE(MAX(created_on)) AS last_transaction_date,
        'investments' AS type
    FROM plans_plan
    WHERE amount > 0
    GROUP BY id, owner_id
)

SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM transactions
WHERE last_transaction_date < CURDATE() - INTERVAL 365 DAY
ORDER BY inactivity_days DESC;
