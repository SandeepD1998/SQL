create table patients (
pat_id number(4) primary key,
pat_nm varchar2(20),
pat_dob date,
gender char(1),
loc_id references locations(loc_id),
phone_no number(10),
insurence_flag varchar2(20));

insert into patients values(1001,'BHFJ','12-03-1994','M',101,786574563,'Y');
insert into patients values(1002,'CVH','14-05-1974','F',102,786554563,'N');
insert into patients values(1003,'CVGH','13-03-1984','F',103,783474563,'N');
insert into patients values(1004,'FCHB','16-06-1974','M',104,785574563,'N');
insert into patients values(1005,'FGFG','17-07-1984','F',105,784574563,'Y');
insert into patients values(1006,'GFRH','18-08-1994','M',101,786574563,'Y');
insert into patients values(1007,'GFJFBV','19-09-1984','F',101,786574563,'N');
insert into patients values(1008,'HBVNCB','20-05-1994','M',102,786573463,'Y');
insert into patients values(1009,'HCJK','21-03-1997','F',103,786574343,'Y');
insert into patients values(1010,'BFVJH','22-10-1998','F',104,786572363,'Y');
insert into patients values(1011,'BCKV','23-11-1999','T',105,786557663,'N');
insert into patients values(1012,'VHCCBN','24-12-2000','T',105,786578963,'N');
insert into patients values(1013,'BVJBC','25-01-2001','M',104,786573453,'Y');

COMMIT;


create  table locations(
loc_id number(4) primary key,
loc_nm varchar2(20),
loc_type varchar2(20),
state_nm varchar2(20),
country_nm varchar2(20));
insert into locations values(101,'Bangalore','Metro_city','Karnataka','India');
insert into locations values(102,'Mumbai','Metro_city','Maharastra','India');
insert into locations values(103,'Khadi road','Metro_city','Delhi','India');
insert into locations values(104,'Mallippu','Non_Metro_city','Gujarath','India');
insert into locations values(105,'Nelmangala','Metro_city','Karnataka','India');
 
create table doctors (
doc_id number(4) primary key,
doc_nm varchar2(20),
doc_specality varchar2(20));

insert into doctors values(201,'BVJHB','Ortho');
insert into doctors values(202,'JBVGF','Cardiologists');
insert into doctors values(208,'BVJHB','Anesthesiologists');
insert into doctors values(203,'BGTGG','Dermatologists');
insert into doctors values(204,'BVJMB','Endocrinologists');
insert into doctors values(209,'BVJMB','Gastroenterologists');
insert into doctors values(205,'JGFVHJB','Hematologists');
insert into doctors values(206,'BVFNBB','Neurologists');
insert into doctors values(207,'BCJDHBB','Oncologists');


create table treatment (
treat_id number(4) primary key,
treat_type_id references treat_type(treat_type_id),
treat_code varchar2(10),
treat_name varchar2(20),
treat_start_on date);

insert into treatment values(501,301,'ra601','Radiationtherapy','12-07-2017');
insert into treatment values(502,303,'ra602','Radiationtherapy','12-08-2020');
insert into treatment values(503,302,'im603','Immunotherapy','12-07-2021');
insert into treatment values(504,301,'va604','Vaccinetherapy','12-07-2019');
insert into treatment values(505,304,'im604','Immunotherapy','12-07-2018');
insert into treatment values(506,305,'bl605','Bloodtransfusion','12-07-2020');
insert into treatment values(507,309,'va606','Vaccinetherapy','12-07-2019');
insert into treatment values(508,307,'bl607','Bloodtransfusion','12-07-2016');

create table treat_type (
treat_type_id number(4) primary key,
treat_type_desc varchar2(20),
treat_type_code varchar2(10));

insert into treat_type values(301,'Surgery','su401');
insert into treat_type values(302,'Chemotherapy','ch402');
insert into treat_type values(303,'RadiationTherapies','ra403');
insert into treat_type values(304,'Chemotherapy','ch404');
insert into treat_type values(305,'Surgery','su405');
insert into treat_type values(306,'Hormonal Therapy','ho406');
insert into treat_type values(307,'Hormonal Therapy','ho407');
insert into treat_type values(308,'RadiationTherapies','ra408');
insert into treat_type values(309,'TargetedTherapies','ta409');
insert into treat_type values(310,'TargetedTherapies','ta410');


select * from treat_type;

commit;

create table pat_treatment (
pat_treat_id number(4) primary key,
treat_id references treatment(treat_id),
treat_date date,
pat_id references patients(pat_id),
doc_id references doctors(doc_id),
treat_dur_days number(4));

insert into pat_treatment values(801,503,'12-03-2022',1003,201,03);
insert into pat_treatment values(802,503,'11-06-2017',1003,202,10);
insert into pat_treatment values(803,504,'10-08-2018',1004,203,01);
insert into pat_treatment values(804,505,'03-09-2016',1002,204,02);
insert into pat_treatment values(805,506,'08-10-2019',1005,205,08);
insert into pat_treatment values(806,507,'23-11-2020',1006,206,05);
insert into pat_treatment values(807,508,'29-12-2021',1007,207,15);
insert into pat_treatment values(808,508,'12-12-2021',1008,201,11);
insert into pat_treatment values(809,506,'19-01-2019',1009,202,10);
insert into pat_treatment values(810,null,'15-02-2017',1008,203,04);

desc pat_treatment;
commit;

select * from treatment;
select * from patients;
select * from doctors;


1.	Find out different treatments we provide from last three years.

select distinct treat_name
from treatment
where to_char(treat_start_on,'yy') between to_char(sysdate,'yy')-3 and to_char(sysdate,'yy');

2.	Find the number patients we get from each each country.

select country_nm,count(pat_id)
from locations l,patients p
where l.loc_id=p.loc_id
group by country_nm;

3.	Find all the patients who are currently taking the treatment of type Ayurvedic.

select p.pat_nm
from patients p,pat_treatment pt,treatment t
where p.pat_id=pt.pat_id
and pt.treat_id=t.treat_id
and treat_name='Ayurvedic'
and treat_date=sysdate;

4.	Find all the patients who are coming from metro cities (loc_type = 'Metro').

select pat_nm
from patients p,locations l
where p.loc_id=l.loc_id
and loc_type='Metro_city';

5.	Find the number of customers who are having insurance.

select insurence_flag,count(pat_id) 
from patients
where insurence_flag='Y'
group by insurence_flag;

6.	Find all the days where we provided more than 100 treatments in Ayurvedic type.

select to_char(treat_date,'dd-mm-yy'),count(t.treat_id)
from pat_treatment p,treatment t
where p.treat_id=t.treat_id 
and treat_name='Ayurvedic'
group by to_char(treat_date,'dd-mm-yy')
having count(t.treat_id)>100;

7.	Find the doctor who have the most number of treatments on 03-JAN-2013.

select doc_nm,count(treat_id)
from doctors d,pat_treatment p
where d.doc_id=p.doc_id
group by doc_nm
having count(treat_id)>(select count(treat_id)
                                            from pat_treatment
                                            where to_char(treat_date,'dd-mon-yyyy')='03-Jan-2013'
                                            group by to_char(treat_date));
                                            
                                          
8.	Find the doctor who did not have any treatments on 03-JAN-2013.

select distinct doc_nm
from doctors
where doc_id not in (select doc_id 
                                    from pat_treatment
                                    where to_char(treat_date,'dd-mon-yyyy')='03-Jan-2013');
                                    
9.	Find the treatments which were commonly given by both Doctor ‘RAM’ and ‘TIM’ gave on 03-JAN-2013.

select treat_name
from treatment t,pat_treatment p,doctors d
where t.treat_id=p.treat_id
and p.doc_id=d.doc_id
and doc_nm ='ram' and doc_nm='tim'
and to_char(treat_date,'dd-mon-yyyy')='03-jan-2013';


10.	Create a view which gives us the Patient Name, Country Name and the treatment they took in the current month. Call the view as vw_current_month_patients

create view vw_current_month_patients as
select pat_nm,country_nm,treat_name
from patients p,locations l,treatment t,pat_treatment pt
where p.loc_id=l.loc_id
and p.pat_id=pt.pat_id
and pt.treat_id=t.treat_id
and to_char(treat_date,'mm-yy')=to_char(sysdate,'mm-yy');



