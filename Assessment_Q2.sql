USE adashi_staging;

-- this creates a temporary table to get customer frequency of transactions 
WITH monthlytransactions as (
                            SELECT owner_id, 
                                    count(owner_id) as frequency, 
                                    date_format(transaction_date, '%Y-%m') yearmonth ,
								CASE 
                                    WHEN count(owner_id) <=2 THEN "Low Frequency" 
									WHEN count(owner_id) <9 THEN "Medium Frequency"
                                    ELSE 'High Frequency'
                                    END as frequency_category
							FROM savings_savingsaccount
							GROUP BY date_format(transaction_date, '%Y-%m'), owner_id
                            ) 
                            
SELECT frequency_category, 
        count(frequency_category), 
        avg(frequency)
FROM monthlytransactions
GROUP BY frequency_category