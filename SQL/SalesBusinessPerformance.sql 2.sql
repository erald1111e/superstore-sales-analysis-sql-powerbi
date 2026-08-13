CREATE OR ALTER VIEW dbo.vw_Sales_Clean
AS
SELECT
    Row_ID,
    Order_ID,
    Order_Date,
    Ship_Date,
    Ship_Mode,
    Customer_ID,
    Customer_Name,
    Segment,
    Country,
    City,
    State,
    Postal_Code,
    Region,

    Product_ID,
    Product_Name,
    CONCAT(Product_ID, '|', Product_Name) AS Product_Key,

    Category,
    Sub_Category,

    Sales,
    Quantity,
    Discount,
    COALESCE(Profit, 0) AS Profit,

    DATEDIFF(DAY, Order_Date, Ship_Date) AS Delivery_Days,

    CASE
        WHEN Sales = 0 THEN 0
        ELSE COALESCE(Profit, 0) / Sales
    END AS Profit_Margin,

    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    DATENAME(MONTH, Order_Date) AS Order_Month_Name,
    CONCAT('Q', DATEPART(QUARTER, Order_Date)) AS Order_Quarter,

    DATEFROMPARTS(
        YEAR(Order_Date),
        MONTH(Order_Date),
        1
    ) AS Order_Year_Month

FROM dbo.raw_superstore

WHERE
    Row_ID IS NOT NULL
    AND Order_ID IS NOT NULL
    AND Order_Date IS NOT NULL
    AND Ship_Date IS NOT NULL
    AND Customer_ID IS NOT NULL
    AND Product_ID IS NOT NULL
    AND Sales IS NOT NULL
    AND Quantity IS NOT NULL
    AND Ship_Date >= Order_Date;


    SELECT TOP 10
    Product_ID,
    Product_Name,
    Product_Key,
    Order_Date,
    Order_Year,
    Order_Month,
    Order_Month_Name,
    Order_Quarter,
    Order_Year_Month
FROM dbo.vw_Sales_Clean;


SELECT
    Product_ID,
    Product_Name,
    COUNT(*) AS Row_Count
FROM dbo.vw_Sales_Product
GROUP BY
    Product_ID,
    Product_Name
HAVING COUNT(*) > 1;



SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Product_Key) AS Unique_Product_Keys
FROM dbo.vw_Sales_Product;





CREATE OR ALTER VIEW dbo.vw_Sales_Product
AS
SELECT
    Product_ID,
    Product_Name,
    CONCAT(Product_ID, '|', Product_Name) AS Product_Key,

    Category,
    Sub_Category,

    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    CASE
        WHEN SUM(Sales) = 0 THEN 0
        ELSE SUM(Profit) / SUM(Sales)
    END AS Profit_Margin

FROM dbo.vw_Sales_Clean

GROUP BY
    Product_ID,
    Product_Name,
    Category,
    Sub_Category;
GO

CREATE OR ALTER VIEW dbo.vw_Sales_Monthly
AS
SELECT
    Order_Year,
    Order_Month,
    Order_Month_Name,
    Order_Quarter,
    Order_Year_Month,

    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,

    COUNT(DISTINCT Order_ID) AS Total_Orders,

    CASE
        WHEN SUM(Sales) = 0 THEN 0
        ELSE SUM(Profit) / SUM(Sales)
    END AS Profit_Margin

FROM dbo.vw_Sales_Clean

GROUP BY
    Order_Year,
    Order_Month,
    Order_Month_Name,
    Order_Quarter,
    Order_Year_Month;
GO


SELECT TOP 10 *
FROM dbo.vw_Sales_Clean;


SELECT TOP 10 *
FROM dbo.vw_Sales_Monthly
ORDER BY Order_Year_Month;


SELECT TOP 10 *
FROM dbo.vw_Sales_Product
ORDER BY Total_Sales DESC;


