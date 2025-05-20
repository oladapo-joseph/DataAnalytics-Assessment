USE adashi_staging;
-- This SQL query calculates the estimated Customer Lifetime Value (CLV) for users based on their savings and investment transactions.

-- The profit per transaction is set to 0.001 (0.1%).
SET @profit_per_transaction = 0.001 ;
SET @naira_conversion = 0.01;

WITH funded_savings AS (
    SELECT owner_id, count(owner_id) as savings_count, SUM(amount) AS savings_total
    FROM savings_savingsaccount
    WHERE amount !=0
    GROUP BY owner_id
),
funded_investments AS (
    SELECT owner_id, count(owner_id) as invest_count, SUM(amount) AS investment_total
    FROM plans_plan
    WHERE amount !=0
    GROUP BY owner_id
)

SELECT 
    u.id AS customer_id,
    u.name,
    (fs.savings_count + fi.invest_count) AS total_transactions,
    -- Tenure in months (rounded down to integer)
    CONVERT((DATEDIFF(CURDATE(), u.created_on) / 30), UNSIGNED) AS Tenure,
    -- Estimated CLV calculation
    ROUND(
        ((fs.savings_total + fi.investment_total)/ NULLIF((DATEDIFF(CURDATE(), u.created_on) / 30), 0))
        * 12 * @profit_per_transaction* @naira_conversion,
        2) AS estimated_clv
FROM users_customuser u
JOIN funded_investments fi ON fi.owner_id = u.id
JOIN funded_savings fs ON fs.owner_id = u.id

ORDER BY estimated_clv DESC;

