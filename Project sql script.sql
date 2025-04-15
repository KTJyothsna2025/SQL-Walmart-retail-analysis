Task 1: Identifying the Top Branch by Sales Growth Rate (6 Marks)
Walmart wants to identify which branch has exhibited the highest sales growth over time. Analyze the total sales
for each branch and compare the growth rate across months to find the top performer.

ALTER TABLE `walmartsales dataset - walmartsales`
MODIFY COLUMN Date DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE `walmartsales dataset - walmartsales`
SET `Date` = STR_TO_DATE(`Date`, '%d-%m-%Y');


SELECT 
    Branch, 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS Month,
    SUM(Total) AS Total_Sales,
    (SUM(Total) - LAG(SUM(Total)) OVER (PARTITION BY Branch ORDER BY DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m'))) / 
    LAG(SUM(Total)) OVER (PARTITION BY Branch ORDER BY DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m')) AS Growth_Rate
FROM `walmartsales dataset - walmartsales`
GROUP BY Branch, Month
ORDER BY Growth_Rate DESC
LIMIT 1;



-----Task 2: Finding the Most Profitable Product Line for Each Branch (6 Marks)
Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
should be calculated based on the difference between the gross income and cost of goods sold.

SELECT 
    Branch, 
    Product_line, 
    SUM(cogs-'gross income') AS Total_Profit
FROM `walmartsales dataset - walmartsales`
GROUP BY Branch, Product_line
ORDER BY Branch, Total_Profit DESC;
 
 
 -----Task 3: Analyzing Customer Segmentation Based on Spending (6 Marks)
Walmart wants to segment customers based on their average spending behavior. Classify customers into three
tiers: High, Medium, and Low spenders based on their total purchase amounts.




SELECT 
    Customer_ID, 
    CASE 
        WHEN sum(Total)  > 23000 THEN 'High'
        WHEN sum(Total) BETWEEN 20000 AND 23000 THEN 'Medium'
        ELSE 'Low'
    END AS Spending_Tier
FROM `walmartsales dataset - walmartsales`
GROUP BY Customer_ID;

//checking thresholds
SELECT 
    Customer_ID, 
    SUM(Total) AS Total_Spent
FROM `walmartsales dataset - walmartsales`
GROUP BY Customer_ID
ORDER BY Total_Spent DESC;

----Task 4: Detecting Anomalies in Sales Transactions 
Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies.

SELECT 
    Invoice_ID,
    Product_line,
    Total,
    CASE 
        WHEN Total > 1000 THEN 'High Anomaly'
        WHEN Total < 50 THEN 'Low Anomaly'
        ELSE 'Normal'
    END AS Anomaly_Status
FROM `walmartsales dataset - walmartsales`;

----Task 5: Most Popular Payment Method by City (6 Marks)
Walmart needs to determine the most popular payment method in each city to tailor marketing strategies.

select city, payment, count(*) as usage_count
from `walmartsales dataset - walmartsales`
group by city,payment
order by city, count(*);

---Task 6: Monthly Sales Distribution by Gender (6 Marks)
Walmart wants to understand the sales distribution between male and female customers on a monthly basis.
 
 select gender, DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS Month
 ,sum(total) as total_sales
 from `walmartsales dataset - walmartsales`
 group by gender,month
 order by total_sales;
 
 
 ---Task 7: Best Product Line by Customer Type (6 Marks)
Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).

select customer_type,product_line,sum(total) as total_sales
from `walmartsales dataset - walmartsales`
group by customer_type,product_line
order by customer_type,total_sales desc;

-----Task 8: Identifying Repeat Customers (6 Marks)
Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30
days).




SELECT 
    Customer_ID, 
    COUNT(*) AS Purchase_Count
FROM (
    SELECT 
        Customer_ID, 
        Date, 
        DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m-%d') AS Date_Formatted, 
        LAG(DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m-%d')) OVER (PARTITION BY Customer_ID ORDER BY DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m-%d')) AS Prev_Date_Formatted
    FROM `walmartsales dataset - walmartsales`
) AS Subquery
WHERE DATEDIFF(Date_Formatted, Prev_Date_Formatted) <= 30 
    AND Prev_Date_Formatted IS NOT NULL 
GROUP BY Customer_ID
HAVING Purchase_Count > 1;

---Task 9: Finding Top 5 Customers by Sales Volume (6 Marks)
Walmart wants to reward its top 5 customers who have generated the most sales Revenue.

select customer_id,sum(total) as total_sales
from `walmartsales dataset - walmartsales`
group by customer_id
order by total_sales desc
limit 5;

---Task 10: Analyzing Sales Trends by Day of the Week (6 Marks)
Walmart wants to analyze the sales patterns to determine which day of the week
brings the highest sales.

SELECT
    DAYNAME(STR_TO_DATE(Date, '%Y-%m-%d')) AS Day_of_Week, 
    SUM(Total) AS Total_Sales
FROM `walmartsales dataset - walmartsales`
GROUP BY Day_of_Week
ORDER BY 
    FIELD(Day_of_Week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
    
    