/*-- get first and last name of users from users_customuser table and sum the values for 
savings and investments taking into account only plans that are funded 
and customers with just 1 investment plan and more than 1 savings plan --*/

SELECT 
	u.id owner_id, 
    concat(first_name, ' ' ,last_name) AS name, 
    s1.savings_count AS savings_count,
    s2. investment_count AS investment_count,
    (s1.total_savings + s2.total_investments) AS total_deposits
FROM users_customuser u
JOIN (
	SELECT 
		owner_id, 
        COUNT(DISTINCT savings_id) savings_count,
        SUM(new_balance) AS total_savings
    FROM savings_savingsaccount
    WHERE new_balance > 0
    GROUP BY owner_id) s1 
ON s1.owner_id=u.id
JOIN (
	SELECT 
		owner_id, 
        COUNT(DISTINCT id) investment_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE amount > 0
    GROUP BY owner_id
    HAVING investment_count = 1) s2
ON s2.owner_id = u.id
ORDER BY total_deposits DESC
