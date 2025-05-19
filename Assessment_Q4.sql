/*-- STEP 1: Join the users table with the savings transactions table
--   - Match each user to their savings transactions using owner_id

-- STEP 2: For each customer (grouped by id, name, and signup date):
--   - Calculate the tenure in months since signup using TIMESTAMPDIFF(MONTH, created_on, CURDATE())
--   - Calculate the total transaction volume by summing verification_call_amount

-- STEP 3: Estimate Customer Lifetime Value (CLV) using the formula:
--   CLV = (Total Transactions / Tenure in Months) * 12 * Average Profit per Transaction
--     • Total Transactions: SUM(verification_call_amount)
--     • Tenure: TIMESTAMPDIFF result
--     • 12: Projects the average monthly value into a yearly estimate
--     • Average Profit per Transaction: AVG(0.1% of transaction amount)

-- STEP 4: Sort the customers in descending order of estimated CLV
--   - This helps prioritize the most valuable customers*/

SELECT 
	u.id customer_id, 
    CONCAT(first_name, ' ' ,last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) as tenure_months,
    SUM(s.verification_call_amount) as total_transactions,
    (sum(s.verification_call_amount)/TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()))*12*(AVG(s.verification_call_amount*0.001)) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s
ON u.id = s.owner_id
Group by 1,2,3
ORDER BY estimated_clv DESC
