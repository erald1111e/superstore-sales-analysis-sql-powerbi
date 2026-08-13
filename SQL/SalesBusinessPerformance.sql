-- krijoj view per performance mujore


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

    -- kontrolloj view

    SELECT *
FROM dbo.vw_Sales_Monthly
ORDER BY Order_Year_Month;

SELECT
    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,
    SUM(Total_Quantity) AS Total_Quantity,
    SUM(Total_Orders) AS Total_Orders
FROM dbo.vw_Sales_Monthly;

-- Category & subcategory Performance



CREATE OR ALTER VIEW dbo.vw_Sales_Category
AS
SELECT
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
    Category,
    Sub_Category;


    -- kontrollojme njelloj si tek query e pare

    SELECT *
FROM dbo.vw_Sales_Category
ORDER BY Total_Sales DESC;

-- gjejme 10 sub categorite me marzhin me te ulet te fitimit

SELECT TOP 10
    Category,
    Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM dbo.vw_Sales_Category
ORDER BY Profit_Margin ASC;

-- krijojme view regional performance per te analizuar performancen ne baze te rajoneve


CREATE OR ALTER VIEW dbo.vw_Sales_Region
AS
SELECT
    Region,

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
    Region;

    -- kontrolli 

    SELECT
    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,
    SUM(Total_Quantity) AS Total_Quantity
FROM dbo.vw_Sales_Region;

-- rajoni me fitimprures

SELECT TOP 1
    Region,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM dbo.vw_Sales_Region
ORDER BY Total_Profit DESC;

-- view per Product Performance



CREATE OR ALTER VIEW dbo.vw_Sales_Product
AS
SELECT
    Product_ID,
    Product_Name,
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


    -- top 10 product by sales

    SELECT TOP 10
    Product_Name,
    Category,
    Sub_Category,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM dbo.vw_Sales_Product
ORDER BY Total_Sales DESC;

-- view customer performance



CREATE OR ALTER VIEW dbo.vw_Sales_Customer
AS
SELECT
    Customer_ID,
    Customer_Name,
    Segment,

    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity,

    CASE
        WHEN SUM(Sales) = 0 THEN 0
        ELSE SUM(Profit) / SUM(Sales)
    END AS Profit_Margin

FROM dbo.vw_Sales_Clean

GROUP BY
    Customer_ID,
    Customer_Name,
    Segment;

    -- top 10 klientet sipas sales

    SELECT TOP 10
    Customer_ID,
    Customer_Name,
    Segment,
    Total_Orders,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM dbo.vw_Sales_Customer
ORDER BY Total_Sales DESC;

-- top 10 klientet sipas profit

SELECT TOP 10
    Customer_ID,
    Customer_Name,
    Segment,
    Total_Orders,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM dbo.vw_Sales_Customer
ORDER BY Total_Profit DESC;


--- klientet qe gjenerojne humbje

SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    Total_Orders,
    Total_Sales,
    Total_Profit,
    Profit_Margin
FROM dbo.vw_Sales_Customer
WHERE Total_Profit < 0
ORDER BY Total_Profit ASC;

-- kontroll per total sales,profit dhe quantity


SELECT
    SUM(Total_Sales) AS Total_Sales,
    SUM(Total_Profit) AS Total_Profit,
    SUM(Total_Quantity) AS Total_Quantity
FROM dbo.vw_Sales_Customer;