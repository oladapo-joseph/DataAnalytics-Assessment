-- Switch to the adashi_staging database
USE adashi_staging;

-- CTE to find inactive savings and investment plans (no activity for over 365 days)
WITH savings_inactive AS (
    -- Get last transaction date for savings accounts with non-zero amount
    SELECT 
        plan_id, 
        owner_id, 
        'savings', 
        MAX(transaction_date) AS Last_transaction_date, 
        DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days
    FROM savings_savingsaccount
    WHERE amount != 0
    GROUP BY owner_id
    HAVING inactivity_days > 365

    UNION ALL

    -- Get last start date for investment plans with non-zero amount
    SELECT 
        plan_type_id, 
        owner_id, 
        'investment', 
        MAX(start_date) AS Last_transaction_date, 
        DATEDIFF(CURDATE(), MAX(start_date)) AS inactivity_days
    FROM plans_plan
    WHERE amount != 0
    GROUP BY  owner_id
    HAVING inactivity_days > 365
)

-- Return all inactive savings and investment plans
SELECT * FROM savings_inactive;