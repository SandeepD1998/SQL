1.	Find all the customers who did not make any sales from last two months.

select cust_name
from customer_retail
where cust_id not in (select distinct(cust_id)
                                        from sales_retail
                                        where to_char(sales_date,'dd-mm-yy')>add_months(to_char(sysdate,'dd-mm-yy'),-2));
                                        
select cust_name
from customer_retail
where cust_id not in (select distinct(cust_id)
                                        from sales_retail
                                        where to_char(sales_date,'dd-mm-yy') in (add_months(to_char(sysdate,'dd-mm-yy'),-2),to_char(sysdate,'dd-mm-yy')));
                                        

select add_months(to_char(sysdate,'dd-mm-yy'),-2) from dual;

In this problem we can use the between operator also. 
In this problem we can use the between operator also. 

2.	Find top 10 customers in terms of sales in the current year.

select *
from(select cust_name,amount,dense_rank() 
over(order by amount desc)rnk 
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
and to_char(sales_date,'yy')=to_char(sysdate,'yy')) w
where rnk<=10;


3.	How many different cities from which we have our customers

select cust_name,count(cust_city)
from customer_retail
group by cust_name

select cust_id,count(cust_city)
from customer_retail
group by cust_id;


4.	Find customers who are from the same city as Customer ‘TIM’.

select cust_name
from  customer_retail
where cust_city = (select cust_city 
                                from customer_retail
                                where cust_name='TIM');
                                
                                
5.	Find how many different customers we got yesterday.

select count(cust_id)
from sales_retail s
where to_char(sales_date,'dd')=to_char(sysdate,'dd')-1;

select to_char(sysdate,'dd')-1 from dual;

6.	Find the date in the current month which gave the least total sales amount. For example on 1-Jan-13 we sold for 3000 Rs, and on 2-Jan-13 we sold total of 8000 (In this case the answer should be 1-Jan-13)

select to_char(sales_date),min(amount)
from sales_retail
where to_char(sales_date,'mm')=to_char(sysdate,'mm')
group by to_char(sales_date);


7.	Create a view which gives Customer_Name, Month and total revenue we got.

create view cust_views as
select cust_name,to_char(sales_date,'mon') month,sum(amount) as total_revenue
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
group by cust_name,to_char(sales_date,'mon');

select * from cust_views;

8.	Create a view which gives customer_name, city, year, revenue we got.

create view cust_viess as
select cust_name,cust_city,to_char(sales_date,'yy') year,sum(amount) as total_revenue
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
group by cust_name,cust_city,to_char(sales_date,'yy');

select * from cust_viess;

9.	Create an index (non cluster index) on cust_nm column in Customer table.

create index in_cus_retail
on customer_retail(cust_name);

10.	Find the customer who has most number of transactions.

select cust_name,count(sales_id)
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
group by cust_name
having count(sales_id)=(select max(sales_id)
                                            from sales_retail);
                                            
select cust_name,saless
from(select cust_name,count(sales_id) as saless,dense_rank() 
        over(order by count(sales_id) desc)rnk from customer_retail c,sales_retail s
        where c.cust_id=s.cust_id
        group by cust_name) m
where rnk=1;

11.	Display the citywise current year YTD and previous year YTD.
City_name	Current_YTD	   Prev_YTD

select cust_city,
count(case when to_char(sales_date,'yy')=to_char(sysdate,'yy') then sales_id
            end ) Current_ytd ,
count(case when to_char(sales_date,'yy')=to_char(sysdate,'yy') then sales_id
            end ) Pre_ytd 
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
group by cust_city;
            
12.	Display cities that have more number of customers than the city ‘HYD’.

select cust_city,count(cust_id)
from customer_retail
group by cust_city
having count(cust_id)>(select count(cust_id)
                                        from customer_retail
                                        where cust_city='HYD'
                                        group by cust_name);
                                        
select * from customer_retail;

13.	Display citywise number of customers and number of transactions in the current year.

select cust_city,count(c.cust_id) as cci,csi 
from(select cust_id,count(sales_id) as csi
          from sales_retail
          where to_char(sales_date,'yy')=to_char(sysdate,'yy')
          group by cust_id) d,customer_retail c
where d.cust_id=c.cust_id
group by cust_city;


14.	Display the customers who made sales yesterday and today.

select cust_name
from customer_retail
where cust_id=(select cust_id
                            from sales_retail
                            where to_char(sales_date,'dd') in ((to_char(sysdate,'dd')),(to_char(sysdate,'dd')-1)));
                            
15.	Display the cities whose number of customers ids more than the number of customers in city ‘Chennai’.

select cust_city,count(cust_id)
from customer_retail
group by cust_city
having count(cust_id)>(select count(cust_id)
                                        from customer_retail
                                        where cust_city='chennai'
                                        group by cust_name);
                                        
                                        
16.	Write a query to get the output
Display the customers and their status as ‘Made sales’ or ‘No sales’ in the current year.
Cust_name	Status
A		Made sales
B		Made sales
C		Nosales

select cust_name,case when sales_id=null then 'No sales'
                                    else 'Made sales'
                                    end status
from customer_retail c,sales_retail s
where c.cust_id=s.cust_id
and to_char(sales_date,'yy')=to_char(sysdate,'yy');

17. Display the top 1 customer based on sales in every year.

select cust_name
from(select cust_name,sum(amount),dense_rank() 
        over(partion by to_char(sales_date,'yy') order by sum(amount) desc)rnk
        from customer_retail c,sales_retail s
        where c.cust_id=s.cust_id
        group by cust_name) mno
        where rnk=1;

