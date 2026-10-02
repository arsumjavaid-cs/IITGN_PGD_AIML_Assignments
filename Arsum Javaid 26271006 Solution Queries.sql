select event_id, store_id, product_code, base_price, promo_type
from fact_events
where base_price > 1000;



-- Q2
select event_id, product_code, promo_type, `quantity_sold(before_promo)`, `quantity_sold(after_promo)`
from fact_events
where `quantity_sold(after_promo)` > 100
order by `quantity_sold(after_promo)` desc;


-- Q3
select distinct promo_type
from fact_events;


-- Q4
select count(event_id) as `total number of events`, sum(`quantity_sold(before_promo)`) as `Total Quantity Sold Before Promotion`,
 sum(`quantity_sold(after_promo)`) as `Total Quantity Sold After Promotion`, avg(base_price) as `Average Base Price`, max(base_price) as `Maximum Base Price`, min(base_price) as `Minimum Base Price`
 from fact_events;
 
 -- Q5
 select promo_type, count(event_id) as `Number of Events`, sum(`quantity_sold(before_promo)`) as `Total Quantity Sold Before Promotion`,
 sum(`quantity_sold(after_promo)`) as `Total Quantity Sold After Promotion`
 from fact_events
 group by promo_type
 order by `quantity_sold(after_promo)` desc;
 
 
 -- Q6
 
 select promo_type, `quantity_sold(before_promo)` as `Total Quantity Before Promotion`,
 `quantity_sold(after_promo)` as `Total Quantity After Promotion`,
 (`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) as `Quantity Increase/Decrease`
 from fact_events
 group by promo_type
 order by (`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) desc; 
 
 
 -- Q7
 select p.product_code, p.product_name, p.category, sum(e.`quantity_sold(after_promo)`) as `Total Quantity After Promo`
 from fact_events as e
 join dim_products as p
 on e.product_code = p.product_code
 group by p.product_code, p.product_name, p.category
 order by sum(e.`quantity_sold(after_promo)`) desc;
 
 
 -- Q8
 select category, count(event_id) as `Number of Events`, sum(`quantity_sold(before_promo)`) as `Total Quantity Before Promotion`,
 sum(`quantity_sold(after_promo)`) as `Total Quantity After Promotion`, (`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) as `Quantity Change`
 from fact_events as e
 join dim_products as p
 on e.product_code = p.product_code
 group by category
 order by `quantity_sold(after_promo)` desc;

 -- Q9
select  city, count(event_id) as event_count, sum(`quantity_sold(before_promo)`) as `Total Before`, sum(`quantity_sold(after_promo)`) as `Total After`
from fact_events as e
join dim_stores as s
on e.store_id = s.store_id
group by city
order by sum(`quantity_sold(after_promo)`) desc;


-- Q10
select c.campaign_name, c.start_date, c.end_date, count(e.event_id) as `Number of Events`, sum(`quantity_sold(before_promo)`) as `Total qty Before promo`, sum(`quantity_sold(after_promo)`) as `Total Qty After Promo`
from fact_events as e
join dim_campaigns as c
on e.campaign_id = c.campaign_id
group by e.campaign_id, c.campaign_name, c.start_date, c.end_date
order by sum(`quantity_sold(after_promo)`) desc;

-- Q11
select p.category, sum(e.`quantity_sold(after_promo)`) as `Total Qty After Promo`, avg(e.base_price) as `Average Base Price`
from fact_events as e
join dim_products as p
on e.product_code = p.product_code
group by p.category
having sum(e.`quantity_sold(after_promo)`) > 1000
order by sum(e.`quantity_sold(after_promo)`) desc;


-- Q12
select s.city, p.category, sum(e.`quantity_sold(after_promo)`) as `Total Qty After Promo`
from fact_events as e
join dim_stores as s
on e.store_id = s.store_id
join dim_products as p
on e.product_code = p.product_code
group by s.city, p.category
order by s.city asc, sum(e.`quantity_sold(after_promo)`) desc;

-- Q13
select product_name, category, sum(`quantity_sold(before_promo)`) as `Total qty Before promo`, sum(`quantity_sold(after_promo)`) as `Total Qty After Promo`,
(`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) as `Quantity Change`,
(((`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) as `Percentage Change`
from dim_products as p
join fact_events as e
on p.product_code = e.product_code
group by p.product_code, p.product_name
order by `Percentage Change` desc;


-- Q14
select c.campaign_name, e.promo_type, count(e.event_id) as `Number of Events`, sum(`quantity_sold(before_promo)`) as `Total qty Before promo`, sum(`quantity_sold(after_promo)`) as `Total Qty After Promo`,
(`quantity_sold(after_promo)` - `quantity_sold(before_promo)`) as `Quantity Change`
from fact_events as e
join dim_campaigns as c
on e.campaign_id = c.campaign_id
group by c.campaign_name, e.promo_type
order by campaign_name asc, `Quantity Change` desc;


-- Q15
select p.product_name, p.category, (e.base_price * e.`quantity_sold(before_promo)`) as `revenue_before`, 
(e.base_price * e.`quantity_sold(after_promo)`) as `revenue_after`, 
((e.base_price * e.`quantity_sold(after_promo)`) - (e.base_price * e.`quantity_sold(before_promo)`)) as `Revenue Difference`
from fact_events as e
join dim_products as p
on e.product_code = p.product_code
group by p.product_code, p.product_name, p.category
order by ((e.base_price * e.`quantity_sold(after_promo)`) - (e.base_price * e.`quantity_sold(before_promo)`)) desc;

-- Q16
select promo_type, sum(`quantity_sold(before_promo)`) as `Total Before`, sum(`quantity_sold(after_promo)`) as `Total After`,
(((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) as `Percentage Change`
, CASE WHEN (((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) >= 50 THEN "High Impact"
WHEN (((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) >= 20 THEN "Medium Impact"
WHEN (((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) < 20 THEN "Low Impact"
END AS `Performance`
from fact_events
group by promo_type
order by (((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) desc;


-- Q17
with temp as (
select p.category as Category, p.product_name as ProductName, sum(`quantity_sold(after_promo)`) as `Total Qty Sold After Promotion`,
row_number() over (
partition by p.category
order by sum(`quantity_sold(after_promo)`)
) as Category_Rank
from fact_events as e
join dim_products as p
on e.product_code = p.product_code
group by p.product_code
)
select Category, ProductName, `Total Qty Sold After Promotion`, Top_2
from temp
where Category_Rank <=2;


-- Q18
with temp as (
select s.city, s.store_id, sum(`quantity_sold(after_promo)`) as `Total Qty Sold After Promotion`,
row_number() over (partition by s.city order by sum(`quantity_sold(after_promo)`) desc) as CityRank
from fact_events as e
join dim_stores as s
on e.store_id = s.store_id
group by s.store_id
)
select * 
from temp
where CityRank <=2;


-- Q19 
with temp as (
select campaign_name as CampaignName, product_name as ProductName, 
sum(`quantity_sold(before_promo)`) as `Total Qty Sold Before promo`, sum(`quantity_sold(after_promo)`) as `Total Qty Sold After Promo`,
(sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) as `Quantity Change`, 
(((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) as `Percentage Change`,
row_number() over (partition by campaign_name order by (((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) desc) as CampaignRank
from fact_events as e
join dim_campaigns as c
on e.campaign_id = c.campaign_id
join dim_products as p
on e.product_code = p.product_code
group by campaign_name, product_name
)

select *
from temp
where CampaignRank <=3;


-- Q20
with temp as (
select product_name, category, count(event_id) as `Number of Promotional Events`,  
sum(`quantity_sold(before_promo)`) as `Total Qty Sold Before promo`, sum(`quantity_sold(after_promo)`) as `Total Qty Sold After Promo`,
(sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) as `Quantity Change`, 
(((sum(`quantity_sold(after_promo)`) - sum(`quantity_sold(before_promo)`)) * 100) / NULLIF(sum(`quantity_sold(before_promo)`), 0)) as `Percentage Change`,
sum(e.base_price * e.`quantity_sold(before_promo)`) as `revenue_before`, 
sum(e.base_price * e.`quantity_sold(after_promo)`) as `revenue_after`,
(sum(e.base_price * e.`quantity_sold(after_promo)`) - sum(e.base_price * e.`quantity_sold(before_promo)`)) as Revenue_Change,
avg(base_price) as `Average Base Price`, 
dense_rank() over (partition by p.category order by (sum(e.base_price * e.`quantity_sold(after_promo)`) - sum(e.base_price * e.`quantity_sold(before_promo)`)) desc) as Ranking
from fact_events as e
join dim_products as p
on e.product_code = p.product_code
group by p.product_code
)

select * 
from temp
where Ranking <=2;

