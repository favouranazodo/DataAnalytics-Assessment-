-- STEP 1: Collect savings account activity
--   - For each savings account (identified by `id`), get:
--       • The owner ID
/*--       • The most recent transaction date using MAX(transaction_date)
--       • Tag the record as type = 'savings'
--   - Filter only funded accounts (new_balance > 0)
--   - Group by account and owner

-- STEP 2: Collect investment plan activity
--   - For each investment plan (identified by `id`), get:
--       • The owner ID
--       • The most recent date the plan was created (as a proxy for transaction date)
--       • Tag the record as type = 'investments'
--   - Filter only funded plans (amount > 0)
--   - Group by account and owner

-- STEP 3: Combine both savings and investment activity using UNION ALL
--   - This creates a unified list of all active accounts with their latest activity

-- STEP 4: From the combined list:
--   - Calculate the number of days since the last transaction using DATEDIFF
--   - Filter for accounts where the last activity was more than 365 days ago
--   - Order the result by most inactive accounts first (descending inactivity_days)*/


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
