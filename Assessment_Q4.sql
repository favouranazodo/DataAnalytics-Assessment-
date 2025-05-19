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