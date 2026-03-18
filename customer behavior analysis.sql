select * from customer limit 20

--what is the total revenue genarated  by male va female customers?

select gender,sum(purchase_amount)as revenue
from customer
group by gender;

--which customer usd a discount but still spent mare the average purchase_amount

select customer_id, purchase_amount
from customer
where discount_applied='Yes' and purchase_amount>=(select avg(purchase_amount) from customer);

--which are the top5 product with the highest ave review rating?

select item_purchased,round(avg(review_rating:: numeric),2)as avg_rating
from customer 
group by item_purchased
order by  avg(review_rating) desc
limit 5;

--cumper the average purchase amount brtween standerd and express shipping

select shipping_type,
round(avg(purchase_amount),2)as avg_amount
from customer
where shipping_type in('Standard','Express')
group by shipping_type;

--do subscribed cutomer spend more?compare  avege spend and total revenue 
-- between subscribed and non subscribed

  select  subscription_status,
  count(customer_id)as total_customer,
  round(avg(purchase_amount),2)as avg_spend,
  round(sum(purchase_amount),2) as total_revenu
  from customer 
  group by subscription_status
  order by total_revenu desc;

  -- which 5 product have highest persentage of purchase with discount applied?

  select item_purchased,
  round(100* sum(case when discount_applied='Yes'then 1 else 0 end)/count(*),2)as discount_rate
  from customer
  group by item_purchased 
  order by discount_rate desc
  limit 5;
  --segment customer into new , returning,loyal based on ther total 
  --number of previose purchase and show of each customer

  with customer_type as(
select customer_id,previous_purchases,
 case
 WHEN previous_purchases = 1 then 'new'
 WHEN previous_purchases between 2 and 10 then 'returning'
 else 'loyal'
 end as customer 
 from customer
 )
 select customer,count(*)as number_of_customer
 from customer_type
 group by customer;


 -- what are the top 3 most purchesed product withen each catgory ?

with customer as (
select category,item_purchased,
count(customer_id)as total_orders,
row_number()over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category ,item_purchased

)

select item_rank,category,item_purchased,total_orders
from customer
where item_rank <=3;
 
 