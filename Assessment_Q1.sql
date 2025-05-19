USE adashi_staging;

-- to create temporary tables to get the customers that have atleast one savings 
WITH funded_savings AS (
    SELECT owner_id, count(owner_id) as savings_count, SUM(amount) AS savings_total
    FROM savings_savingsaccount
    WHERE amount !=0
    GROUP BY owner_id
),  
--atleast one investment 
funded_investments AS (
    SELECT owner_id, count(owner_id) as investment_count, SUM(amount) AS investment_total
    FROM plans_plan
    WHERE amount !=0
    GROUP BY owner_id
)

--- combine both tables and calculate the sum of their total deposits (amount)
SELECT 
    u.id AS owner_id,
    u.name,
    fs.savings_count,
    fi.investment_count,
    (fs.savings_total + fi.investment_total) AS total_deposits
FROM users_customuser u
JOIN funded_investments fi ON fi.owner_id = u.id
JOIN funded_savings fs  ON u.id = fs.owner_id
ORDER BY total_deposits DESC;