/*Find out the Total Revenue
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales
 
/* AVG Order value: The avarage amount spent per order, Calculated by dividing the total revenue by the total number of order
SELECT (SUM(total_price)/COUNT(DISTINCT order_id)) AS Avg_Order_value FROM pizza_sales

/* Find out total Pizza Sold
SELECT COUNT(quantity) AS total_pizza_sold FROM pizza_sales

/* Find out Total Order Placed
SELECT COUNT(DISTINCT(order_id)) AS Total_Order_Placed FROM pizza_sales

/*Find Out AVG pizza per order
SELECT SUM(quantity) /COUNT(DISTINCT order_id)  AS Avg_Per_Order FROM pizza_sales

/*CHARTS REQUIREMENT
#Show in which day how many pizza is orderd
select * from pizza_sales

alter table pizza_sales
modify order_date date;

SELECT DAYNAME(order_date) AS Order_Day ,COUNT(DISTINCT order_id) AS total_Orders 
FROM pizza_sales
GROUP BY DAYNAME(order_date);

#Show in which month how many pizza is orderd

SELECT MONTHNAME(order_date) AS MONTH_NAME,COUNT(DISTINCT order_id) AS TOTAL_ORDER
FROM pizza_sales
GROUP BY MONTHNAME(order_date)
ORDER BY TOTAL_ORDER DESC;

/*Percentage of Sales by Pizza Catagory

SELECT * FROM pizza_sales;


SELECT pizza_category,SUM(total_price) AS TOTAL_SALES,
SUM(total_price*100)/(SELECT SUM(total_price) FROM pizza_sales 
Where MONTH(order_date)=1) AS PCT
FROM pizza_sales
Where MONTH(order_date)=1
GROUP BY pizza_category;


/*Find the Percentage of sales of pizza_size
# Quarterly

SELECT pizza_size,CAST(SUM(total_price) AS DECIMAL(10,2)) AS TOTAL_SALES,
CAST(SUM(total_price*100)/(SELECT SUM(total_price) FROM pizza_sales 
WHERE QUARTER(order_date)=1) AS DECIMAL(10,2))AS PCT
FROM pizza_sales
WHERE QUARTER(order_date)=1
GROUP BY pizza_size;


SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category

/* Top 5 Best sellers by REVENUE, Total Quantity and total orders

SELECT pizza_name,SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
Limit 5 ;

/* Bottom 5 sellers By Revenue
SELECT pizza_name,SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
Limit 5 ;

/* Top 5 best sellers by Quantity
Select pizza_name, SUM(quantity) AS Total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_quantity DESC
Limit 5;

/* Bottom 5 best sellers by Quantity
Select pizza_name, SUM(quantity) AS Total_quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_quantity ASC
Limit 5;


/*Top 5 Pizzas by Total Orders

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
limit 5;



