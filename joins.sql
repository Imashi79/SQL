-- Inner join --
/*used to retrieve records that have matching values in both tables involved in the join. 
It combines rows from two or more tables based on a related column, and only rows that
 meet the join condition are included in the result set. */

select customer.customer_name, orders.order_id
from customer
Inner Join orders
on customer.customer_id = orders.customer_id

-- not using inner join 
  select customer.customer_name, orders.order_id
  from customer, orders
  where customer.customer_id = orders.customer_id
--
-- we can join more than two tables based on a related column
select customer.customer_name, orders.order_id, products.name
from customer
Inner Join orders on customer.customer_id = orders.customer_id
Inner Join products on orders.order_id = products.product_id


-- Left join / Left Outer join --
/* Returns all records from the left table and the matching records from the right table.
 If there is no match, the result will contain NULL for the columns from the right table.  */

select customer.customer_name, orders.order_id
from customer
left Join orders
on customer.customer_id = orders.customer_id

-- Right join / Right Outer Join --
/* Returns all records from the right table and the matching records from the left table. 
If there is no match, the result will contain NULL for the columns from the left table. */

select orders.order_id ,customer.customer_name
from orders
Right Join customer
on customer.customer_id = orders.customer_id

-- Full Outer Join --
/* Combines the results of both LEFT JOIN and RIGHT JOIN. It includes all rows from both the left and right tables.
 If no match is found on either side, NULL values are returned for the missing columns. */

select  orders.order_id,customer.customer_name, products.name
from orders
Full outer Join customer on customer.customer_id = orders.customer_id
Full outer join products on orders.order_id = products.product_id

