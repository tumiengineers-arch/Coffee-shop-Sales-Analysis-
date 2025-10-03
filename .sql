| transaction_id | transaction_date | transaction_time | transaction_qty | store_id | store_location  | product_id | unit_price | product_category   | product_type          | product_detail              |
| -------------- | ---------------- | ---------------- | --------------- | -------- | --------------- | ---------- | ---------- | ------------------ | --------------------- | --------------------------- |
| 1              | 1/1/2023         | 7:06:11          | 2               | 5        | Lower Manhattan | 32         | 3.00       | Coffee             | Gourmet brewed coffee | Ethiopia Rg                 |
| 2              | 1/1/2023         | 7:08:56          | 2               | 5        | Lower Manhattan | 57         | 3.10       | Tea                | Brewed Chai tea       | Spicy Eye Opener Chai Lg    |
| 3              | 1/1/2023         | 7:14:04          | 2               | 5        | Lower Manhattan | 59         | 4.50       | Drinking Chocolate | Hot chocolate         | Dark chocolate Lg           |
| 4              | 1/1/2023         | 7:20:24          | 1               | 5        | Lower Manhattan | 22         | 2.00       | Coffee             | Drip coffee           | Our Old Time Diner Blend Sm |
| 5              | 1/1/2023         | 7:22:41          | 1               | 5        | Lower Manhattan | 57         | 3.10       | Tea                | Brewed Chai tea       | Spicy Eye Opener Chai Lg    |
| 6              | 1/1/2023         | 7:22:41          | 1               | 5        | Lower Manhattan | 77         | 3.00       | Bakery             | Scone                 | Oatmeal Scone               |
| 7              | 1/1/2023         | 7:25:49          | 1               | 5        | Lower Manhattan | 22         | 2.00       | Coffee             | Drip coffee           | Our Old Time Diner Blend Sm |
| 8              | 1/1/2023         | 7:33:34          | 2               | 5        | Lower Manhattan | 28         | 2.00       | Coffee             | Gourmet brewed coffee | Columbian Medium Roast Sm   |
| 9              | 1/1/2023         | 7:39:13          | 1               | 5        | Lower Manhattan | 39         | 4.25       | Coffee             | Barista Espresso      | Latte Rg                    |


SELECT * FROM sales.retail.bright_coffee ;    ---Here we displaying the entire table

--Here I am determining the Revenue for each transaction--
SELECT transaction_id,
       transaction_qty*unit_price As revenue
FROM sales.retail.bright_coffee ;

-- Here i want to get the number total number of transacctions by using the "transaction_id" ---
SELECT COUNT(transaction_id) As total_number_of_transactions
FROM sales.retail.bright_coffee ;

--Here i want to know the different  number of  unique stores we have 
-- So if there .....
SELECT COUNT( DISTINCT store_id) As total_number_of_shops
FROM sales.retail.bright_coffee ;


--This one gives use 3 Locations that transactions takes place
--So we have 3 shops
SELECT DISTINCT store_location 
FROM sales.retail.bright_coffee ;


--Here we want the  Shops we saw previously and theirs store id
SELECT DISTINCT store_location , store_id
FROM sales.retail.bright_coffee ;

--Find Revenue per store location or per Shop
SELECT store_location,
       sum(transaction_qty*unit_price) As revenue
FROM sales.retail.bright_coffee
GROUP BY store_location;


--So here i want to see how much each product  we have
--makes in total
SELECT product_category,
       sum(transaction_qty*unit_price) As revenue
FROM sales.retail.bright_coffee
GROUP BY product_category;


-- So i want to see the Revenue for Astoria ONLY if i want for
--other shops i will use AND store_location = 'thershop' AND store_location = 'shop2'
--Third part was for ordering the revenue is descending order
SELECT product_category,
       sum(transaction_qty*unit_price) As revenue
FROM sales.retail.bright_coffee
WHERE store_location = 'Astoria'
GROUP BY product_category
ORDER By revenue DESC;


--So i want the above but for only the first 5 most performing
SELECT product_category,
       sum(transaction_qty*unit_price) As revenue
FROM sales.retail.bright_coffee
WHERE store_location = 'Astoria'
GROUP BY product_category
ORDER By revenue DESC
LIMIT 5;



--So now i want products in astoria that are not performing so i will use ASC
--As you can see we are only filtering for Astoria
SELECT product_category,
       sum(transaction_qty*unit_price) As revenue
FROM sales.retail.bright_coffee
WHERE store_location = 'Astoria'
GROUP BY product_category
ORDER By revenue ASC
LIMIT 5;


-- Here i want to see the the date '2023-01-01'
-- The revenue generated in Astoria with its product
--categgory
SELECT product_category,
       sum(transaction_qty*unit_price) As revenue,
       store_location,
       transaction_date
FROM sales.retail.bright_coffee
WHERE store_location = 'Astoria' And transaction_date = '2023-01-01'
GROUP BY product_category,
        store_location,
        transaction_date
ORDER By revenue DESC;


--I want to know when the shop opens :
-- The shop opens  at 6
SELECT Min(transaction_time) As opening_time
FROM sales.retail.bright_coffee;

--Now what time does it close? at 20:59:32
SELECT max(transaction_time) As close_time
FROM sales.retail.bright_coffee;


-- Now  i want to see How much revenue we make in morning, afternoon, evening and at Night
SELECT product_category,
       sum(transaction_qty*unit_price) As revenue,
       store_location,
       transaction_date,
       transaction_time,
       CASE
           WHEN transaction_time between  '06:00:00' AND '11:59:59' THEN 'Morning'
           WHEN transaction_time between  '12:00:00' AND '17:59:59' THEN 'Afternoon'
           WHEN transaction_time between  '18:00:00' AND '19:59:59' THEN 'Evening'
           WHEN transaction_time >=  '20:00:00'  THEN 'Night'
        END As time_of_day_bucket   
FROM sales.retail.bright_coffee
WHERE store_location = 'Astoria' And transaction_date = '2023-05-01'
GROUP BY product_category,
        store_location,
        transaction_date,
        transaction_time,
        time_of_day_bucket
ORDER By revenue DESC;



--This query calculates revenue per product category per store per transaction 
--(after May 1st, 2023), adds a column to bucket transactions into Morning/Afternoon/Evening/Night, 
--and shows the results with the highest revenue first
SELECT product_category,
       SUM(transaction_qty*unit_price) As revenue,
       store_location,
       transaction_date,
       transaction_time,
       CASE
           WHEN transaction_time between  '06:00:00' AND '11:59:59' THEN 'Morning'
           WHEN transaction_time between  '12:00:00' AND '17:59:59' THEN 'Afternoon'
           WHEN transaction_time between  '18:00:00' AND '19:59:59' THEN 'Evening'
           WHEN transaction_time >=  '20:00:00'  THEN 'Night'
        END As time_of_day_bucket   
FROM sales.retail.bright_coffee
WHERE transaction_date > '2023-05-01'
GROUP BY product_category,
        store_location,
        transaction_date,
        transaction_time,
        time_of_day_bucket
ORDER By revenue DESC;
