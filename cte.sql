-- DECLARE 

WITH base_sale AS (
    SELECT
        CustomerID,
        (Quantity * UnitPrice) AS Sale
    FROM dbo.pet_shop_sales
    ),
    customer_sale AS (
        SELECT 
        CustomerID,
        ROUND(SUM(Sale), 2) AS CustomerRevenue
        FROM base_sale
        GROUP BY CustomerID
    ),
    Ranked_Sale AS (
        SELECT
            CustomerID,
            CustomerRevenue,
            ROW_NUMBER() OVER(ORDER BY CustomerRevenue DESC) cum_customer,
            COUNT(*) OVER() AS TotalCustomer,
            ROUND(SUM(CustomerRevenue) OVER(ORDER BY CustomerRevenue DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS cum_revenue,
            ROUND(SUM(CustomerRevenue) OVER(),2) AS TotalRevenue
        FROM customer_sale
    ),
    Ranked_sale_with_pct AS (
        SELECT
            CustomerID,
            CustomerRevenue,
            cum_customer,
            TotalCustomer,
            cum_revenue,
            TotalRevenue,
            ROUND((cum_revenue / TotalRevenue), 2) AS cum_sales_share,
            ROUND((cum_customer / TotalCustomer), 2) AS cum_pct_customer
        FROM Ranked_Sale
    )

    
SELECT * FROM Ranked_sale_with_pct