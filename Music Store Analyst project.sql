use Music_Database;


# 1 - Who is the senior most employee based on job title ?

select *
from
	employee
order by
	levels desc
limit 1;

# 2- which country have most invoices?

select * from invoice; 

select 
	billing_country, count(*) as Invoices
from
	invoice
group by billing_country
order by invoices desc
;

# 3- WHAT ARE TOP 3 VALUES OF TOTAL INVOICES

select *
from invoice
order by total desc
limit 3;

# 

select * from customer;

select 
	sum(total) as Invoice_Total,
    billing_city
from invoice
group by billing_city
order by Invoice_total desc;

/* 4- WHO IS THE BEST CUSTOMER? tHE CUSTOMER WHO HAS SPENT THE MOST MONEY WILL
BE DECLEARED THE BEST CUSTOMER. WRITE A QUERY THAT RETURNS THE PERSON WHO HAS SPENT THE MOST MONEY */

 SELECT * from customer;
 select customer_id,first_name,count(*) from customer group by customer_id;
 select * from invoice;
 
select 
	customer.customer_id,
    customer.first_name,
    customer.last_name,
    sum(total) as Totals
from
	customer
join invoice
on customer.customer_id = invoice.invoice_id
group by customer.customer_id,customer.first_name,customer.last_name
order by totals desc
;

# 5- WRITE QUERY TO RETURN THE EMAIL,FIRST_NAME,LAST_NAME, AND GENRE OF ALL ROCK MUSIC LISTNER.
# RETURNS YOUR LIST ORDER ALPHABETICALLY BY EMAIL STARTING WITH A

select * from customer;
select * from genre;

select
distinct email,first_name,last_name,g.name
from customer as c
join invoice as i
on c.customer_id = i.customer_id
join invoice_line as il
on i.invoice_id = il.invoice_id
join track as t
on il.track_id = t.track_id
join genre as g
on t.genre_id = g.genre_id
where g.name like 'Rock'	
order by email asc;


# 6- LET'S INVITE THE ARTIST WHO HAVE WRITTENTHE MOST ROCK MUSIC IN OUR DATASET. WRITE A QUERY THAT RETURNS
#THE ARTIST NAME AND TOTAL  TRACK COUNT OF THE TOP 10 ROCK BAND

select * from album2;
select * from track1;

select
	artist.artist_id,artist.name,count(artist.artist_id) as Songs
from track1
join album2 on album2.album_id = track1.album_id
join artist on artist.artist_id = album2.artist_id
join genre on genre.genre_id = track1.genre_id
where genre.name like 'Rock'
group by artist.artist_id,artist.name
order by Songs desc
limit 10;


/* 7- RETURN ALL THE TRACK NAMES THAT HAVE A SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH.
RETURN THE NAME AND MILLISECONDS FIR EACH TARCK.
ORDER BY THE SONG LENGTH WITH THE LONGEST SONGS LISTEF FIRST */

SELECT * FROM TRACK1;	


select 
	name , milliseconds
from track1
where milliseconds > ( select avg(milliseconds) from track1)
order by milliseconds desc;


/*8- FIND HOW MUCH AMOUNT SPENT BY EACH CUSTOMER ON ARTIST?
WRITE A QUERY TO RETURN CUSTOMER NAME,ARTIST NAME AND TOTAL SPENT */

with best_selling_artist as (
select
	art.artist_id,
    art.name as Artist_name,
    sum(inli.unit_price * inli.quantity) as Total_Amount
from
	invoice_line as inli
join track1 as t on t.track_id = inli.track_id
join album2 as a on a.album_id = t.album_id
join artist as art on art.artist_id = a.artist_id
group by 1,2
order by Total_Amount desc
limit 1)
select
	c.customer_id,
    concat(c.first_name,' ',c.last_name) as F_name,
	c.first_name,c.last_name,
    bst.Artist_name,
    sum(inli.unit_price * inli.quantity) as Amount_spent
from
invoice as i
join customer as c on c.customer_id = i.customer_id
join invoice_line as inli on inli.invoice_id = i.invoice_id
join track1 as t on t.track_id = inli.track_id
join album2 as a on a.album_id = t.album_id
join best_selling_artist as bst on bst.artist_id = a.artist_id
group by 1,3,4,5
order by  6 desc;


/* 9- WE WANT TO FIND OUT THE MOST POPULAR MUSIC GENRE FOR EACH COUNTRY. 
WE DETERMINE THE MOST POPULAR GENRE AS THE GENRE WITH THE HIGHEST AMOUNT OF 
PURCHASES. WRITE A QUERY THAT RETURNS EACH COUNTRY ALONG WITH THE TOP GENRE.
FOR COUNTRIES WHERE THE MAXIMUM NUMBER OF PURCHASE IS  SHARED RETURN ALL GENRE. */


with cte as (
select
	customer.country,
    genre.name,
    count(invoice_line.quantity) as Purchase,
    genre.genre_id,
    row_number()
    over(partition by country order by  count(invoice_line.quantity) desc) as RowNo
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track1 on track1.track_id = invoice_line.track_id
join genre on genre.genre_id = track1.genre_id
group by 1,2,4
order by 1 asc, 3 desc)

select * from cte where RowNo  = 1;

/* 10- WRITE A QUERY THAT DETERMINES THE CUSTOMER THAT HAS SPEND THE MOST ON MUSIC FOR EACH COUNTRY.
WRITE A QUERY THAT RETURNS THE COUNTRY ALONG WITH THE TOP CUSTOMER AND HOW MUCH THEY SPENT.
FOR COUNTRIES WHERE THE TOP AMOUNT SPENT IS SHARED, PROVIDE ALL CUSTOMERS WHO SPEND THIS AMOUNT. */

with cte as (
SELECT
	row_number()
    over(partition by billing_country order by sum(total) desc ) as Rowno,
    customer.customer_id,
    billing_country,
    customer.first_name,last_name,
	sum(total) as Total_Spent
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 2,3,4,5
order by 3 asc, 6 desc
)
select * from cte where RowNo = 1;



with cte as (
SELECT
	row_number()
    over(partition by country order by sum(total) desc ) as Rowno,
    customer.customer_id,
    customer.country,
    first_name,
    last_name,
	sum(total) as Total_Spent
from invoice
join customer on customer.customer_id = invoice.customer_id
group by 2,3,4,5
order by 3 asc, 6 desc
)
select * from cte where RowNo = 1;