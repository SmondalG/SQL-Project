--Q: Who is the senior most employee on the job title?

SELECT * FROM employee
ORDER BY levels desc
limit 1

--Q: Which countries have the most Invoices?

SELECT COUNT(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c desc

--Q:What are the top 3 values total invoice?

SELECT total FROM invoice
ORDER BY total desc 
limit 3

--Q:Which city has the best customers? We would like to throw a promotional Music Festivel in the city we made the most 
--money .Write a query that returns one city that has the hights sum of the invoice totals.
--Return both city, name & all invoice totals.

SELECT SUM(total)AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC


--Q:Who is the best customer? The customer who has spent the most money will be declared 
--the best customer.Write a query who ha spent the most money.

select customer.customer_id, customer.first_name,customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

--Q:Write a query to return the email, first name, last name & Genere of all
--Rock music listner. Return your list ordered alphabetically
-- by email starting with A.

SELECT DISTINCT email, first_name,last_name
FROM customer 
JOIN invoice ON customer.customer_id =invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	join genre
	ON track.genre_id = genre.genre_id
	WHERE genre.name like 'Rock'
)
ORDER BY email;


--Q) Lets invite the artist who have written the most rock mock music in our dataset 
--Write query that returns the artist name and total track count of the 
--top 10 rock bands.

SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id= track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id  = track.genre_id
WHERE genre.name like 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

-- Q:Return all the track names that have a song length longer than the average song length.
--Return the name and Mileseconds for each track.Order by the song length with longest songs listed
--first.

SELECT name, milliseconds
FROM TRACK
WHERE milliseconds>(SELECT AVG(milliseconds) AS avg_track_length 
					from track )
ORDER BY milliseconds DESC

--Q) Find how much amount spent by each customer on artist ?
-- Write a query to return customer name, artist name and total spent

WITH best_selling_artist AS(
	SELECT artist.artist_id AS artist_id,artist.name AS artist_name,
	SUM (invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line 
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC 
	LIMIT 1
)

SELECT c.customer_id,c.first_name, c.last_name, bsa.artist_id,
SUM(il.unit_price*il.quantity) AS amout_spent
FROM invoice i
JOIN customer c on c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id= i.invoice_id
JOIN track t ON t.track_id= il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC

-- We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the hghets amount of purchases.
--Write a query that returns each country along with the top genre.
-- For countries where the maximum number of purchases is shared return all shared return all genre.

WITH popular_genre AS
(
	SELECT COUNT(invoice_line.quantity) AS purchases, customer.country,genre.name,genre.genre_id,
	ROW_NUMBER() OVER (PARTITION BY customer.country ORDER BY COUNT (invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice.customer_id
	JOIN customer ON customer.customer_id = invoice_line.invoice_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)

--2nd method

WITH RECURSIVE
	sales_per_country AS(
		SELECT COUNT(*) AS purchases_per_genre, customer.country, genre.name, genre.genre_id
		FROM invoice_line
		JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
		JOIN customer ON customer.customer_id = invoice.customer_id
		JOIN track ON track.track_id = invoice_line.track_id
		JOIN genre ON genre.genre_id = track.genre_id
		GROUP BY 2,3,4
		ORDER BY 2
	),
	max_genre_per_country AS (SELECT MAX(purchases_per_genre) AS max_genre_number, country
		FROM sales_per_country
		GROUP BY 2
		ORDER BY 2)
SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

/* Method 1: using CTE */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

--2nd method 
WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)
SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;






