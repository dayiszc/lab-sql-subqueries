use sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from sakila.inventory;
select film_id, title from sakila.film where title like 'Hunchback Impossible';
select count(*) as 'number_of_copies' from sakila.inventory where film_id = (select film_id from sakila.film
where title like 'Hunchback Impossible');
-- Another way to solve it
select count(*) as copies_count from film f join inventory i on f.film_id = i.film_id where f.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
select avg(length) from sakila.film; -- avg in general for all films -- 115.2720
select  title, length from  film where  length > (select avg(length) from sakila.film) order by length desc; -- list avg for each film (longer than avg)

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select film_id, title from film
where title like 'Alone Trip'; -- film_id 17

select fa.film_id, a.actor_id, concat(a.first_name, ' ', a.last_name) as actor_name from sakila.actor a
join sakila.film_actor fa
on a.actor_id = fa.actor_id
where fa.film_id = (select film_id from sakila.film where title like 'Alone Trip');

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select category_id, name from sakila.category
where name like 'Family';

select title from  sakila.film
where  film_id in (select film_id from film_category where category_id = (select category_id from category where name = 'Family'));

select * from sakila.film f
join sakila.film_category fc
on f.film_id = fc.film_id
where fc.category_id = (select category_id from sakila.category where name like 'Family');

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins.
-- Subquery version
select  first_name, last_name, email from  customer 
where address_id IN (SELECT address_id FROM address WHERE city_id IN (SELECT city_id FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = 'Canada')));
    
-- Join version
select c.first_name, c.last_name, c.email from  customer c
join  address a on c.address_id = a.address_id
join   city ct on a.city_id = ct.city_id
join  country co on ct.country_id = co.country_id
where  co.country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
select actor_id, count(film_id) as film_count from sakila.film_actor
group by actor_id
order by count(film_id) desc; -- list

select actor_id, count(film_id) as film_count from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1; -- actor id most prolific 107 and film count

select actor_id from sakila.film_actor
group by actor_id
order by count(film_id) desc
limit 1; -- only actor id
                    
select f.film_id, f.title, fa.actor_id
from sakila.film f
join sakila.film_actor fa
on f.film_id = fa.film_id
where fa.actor_id = (select actor_id from sakila.film_actor group by actor_id order by count(film_id) desc limit 1);

-- 7. Films rented by the most profitable customer. You can use the customer table and payment table to find the most profitable customer, i.e., the customer that has made the largest sum of payments.
select  f.title
from   film f
join  inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join  payment p on r.rental_id = p.rental_id
where p.customer_id = ( select customer_id from payment group by customer_id order by sum(amount) desc limit 1);

-- Separate steps:
	-- Get the customer_id with the highest total payment.
	-- Use that customer_id to find the films rented by that customer.  
    
select customer_id, sum(amount) as sum_payment from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1;

select customer_id from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1;

select f.film_id, f.title
from sakila.film f
join sakila.inventory i
on f.film_id = i.film_id
join sakila.rental r
on i.inventory_id = r.inventory_id
where r.customer_id = (select customer_id from sakila.payment group by customer_id order by sum(amount) desc limit 1);

-- 8. Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having 
    total_amount_spent > (select avg(total_amount_spent) from (select customer_id, sum(amount) as total_amount_spent from payment group by customer_id) as avg_amounts);



                        


    




