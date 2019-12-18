USE cpsc321;

-- #1
SELECT a.first_name, a.last_name, COUNT(*)
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- #2
SELECT c.name, COUNT(*)
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- #3
SELECT c.first_name, c.last_name, COUNT(*)
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN payment p ON p.rental_id = r.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE p.amount = 2.99
AND f.rating = 'PG'
GROUP BY c.customer_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- #4
SELECT f.title, p.amount
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
WHERE f.rating = 'G'
AND p.amount = (SELECT MAX(p.amount) FROM film f
	JOIN inventory i ON i.film_id = f.film_id
	JOIN rental r ON r.inventory_id = i.inventory_id
	JOIN payment p ON p.rental_id = r.rental_id
	WHERE f.rating = 'G');

-- #5
SELECT name, COUNT(*)
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE f.rating = 'PG'
GROUP BY c.category_id
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
	FROM category c
	JOIN film_category fc ON c.category_id = fc.category_id
	JOIN film f ON f.film_id = fc.film_id
	WHERE f.rating = 'PG'
	GROUP BY c.category_id);
    
-- #6

SELECT f.title, COUNT(*)
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE f.rating = 'G'
GROUP BY i.film_id
HAVING COUNT(*) >= (SELECT AVG(count) FROM (
	SELECT COUNT(*) as count
	FROM film f
	JOIN inventory i ON i.film_id = f.film_id
	JOIN rental r ON r.inventory_id = i.inventory_id
    WHERE f.rating = 'G'
    GROUP BY i.film_id) as x)
ORDER BY COUNT(*) DESC
LIMIT 10;

-- #7
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id != ALL (SELECT a.actor_id
	FROM actor a
	JOIN film_actor fa USING (actor_id)
	JOIN film f USING (film_id)
    WHERE f.rating = 'G');

-- #8
SELECT DISTINCT f.title
FROM film f
WHERE f.film_id NOT IN (SELECT f1.film_id
	FROM film f1
    CROSS JOIN store s
    WHERE s.store_id NOT IN (
		SELECT i1.store_id
        FROM inventory i1
        JOIN film f2 USING (film_id)
        WHERE f2.film_id = f1.film_id
        )
	)
LIMIT 10;

-- #9
SELECT a.actor_id, a.first_name, a.last_name, COUNT(*)/(SELECT COUNT(*)
	FROM film_actor fa_sub
	WHERE fa_sub.actor_id = a.actor_id) AS pct
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f USING (film_id)
WHERE f.rating = 'G'
GROUP BY a.actor_id
ORDER BY pct DESC
LIMIT 10;

-- #10
SELECT f.title
FROM film f
LEFT JOIN film_actor fa USING (film_id)
GROUP BY f.film_id
HAVING COUNT(fa.actor_id) = 0;

-- #11
SELECT f.title
FROM film f
JOIN inventory i USING (film_id)
LEFT JOIN rental r USING (inventory_id)
GROUP BY inventory_id
HAVING COUNT(r.rental_id) = 0;

-- #12
SELECT f.film_id, COUNT(fa.actor_id)
FROM film f
LEFT JOIN film_actor fa USING (film_id)
GROUP BY f.film_id
ORDER BY f.film_id
LIMIT 10;