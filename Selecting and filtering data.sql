-- select --
--select a  a table --
select * from Category
select * from Products
select * from Customer
select * from Orders

-- select one or more specific columns in table--
select name from Category
select name, price, description from Products
select customer_name , phone_number from Customer

-- Filtering--
--where--
select * from Orders
where total_amount > 100

select name,price from Products 
where price > 50

--like--
select * from customer
where customer_name like 'A%' -- first letter should 'A' other letters can be any ('A' != 'a') --

select customer_name from customer
where customer_name like '%n' -- last letter should 'A' other letters can be any --

select customer_name from customer
where customer_name like '_a%'  -- second letter should be 'a'

select customer_name from customer
where customer_name like '%t_'  -- second last letter should be 't'

select name from products
where name like '%Maker%'   -- check 'Maker' contain in name

--IN--
select * from customer 
where city in ('New York', 'NYC')

select * from Orders
where order_rating in (4.5,4.2,4.7)

--is--
select * from Products
where price is NULL

--AND : all conditions should be satisfy--
--OR : should be one or more or all condition satisfy  --
select * from Orders
where total_amount > 50 and total_quantity> 1 

select * from Orders
where total_amount > 50 or total_quantity> 1