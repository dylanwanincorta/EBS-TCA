-- the right way to get the profile attributes is to use get the default from the account level when the site level profile is not defined
SELECT U.SITE_USE_ID, ACCT_PROF.COLLECTOR_ID  , SITE_PROF.COLLECTOR_ID 
FROM HZ_CUST_SITE_USES_ALL  U
INNER JOIN HZ_CUST_ACCT_SITES_ALL S
ON U.CUST_ACCT_SITE_ID = S.CUST_ACCT_SITE_ID
LEFT OUTER JOIN HZ_CUSTOMER_PROFILES  ACCT_PROF
ON  S.CUST_ACCOUNT_ID = ACCT_PROF.CUST_ACCOUNT_ID  
AND ACCT_PROF."SITE_USE_ID" IS NULL 
LEFT OUTER JOIN HZ_CUSTOMER_PROFILES  SITE_PROF
ON  S.CUST_ACCOUNT_ID = SITE_PROF.CUST_ACCOUNT_ID  
AND U.SITE_USE_ID  = SITE_PROF.SITE_USE_ID   
AND SITE_PROF."SITE_USE_ID" IS NOT NULL 
where rownum < 100
/


-- alomst all customer accounts have customer profiles
select * 
from hz_cust_Accounts
where cust_account_id not in (
select ACCT_PROF.CUST_ACCOUNT_ID from HZ_CUSTOMER_PROFILES  ACCT_PROF
where ACCT_PROF."SITE_USE_ID" IS NULL )
/
-- Some site uses do not have customer profiles
select count(*)
from HZ_CUST_SITE_USES_ALL  U
where U.SITE_USE_ID NOT IN (SELECT SITE_PROF.SITE_USE_ID from HZ_CUSTOMER_PROFILES SITE_PROF where  SITE_PROF.SITE_USE_ID is not null)
/

select count(*)
from HZ_CUST_SITE_USES_ALL  U
where NOT EXISTS (SELECT 1 
              from HZ_CUSTOMER_PROFILES SITE_PROF 
              where SITE_PROF.SITE_USE_ID = U.SITE_USE_ID )
/


-- Need two type of customer profiles
-- 1. profiles defined at the site use level
-- 2. profiles defined at account level for those bill to site uses that do not have a profile 
select   SU.SITE_USE_ID, COALESCE(SITE_PROF.SITE_USE_ID, 0) PROF_SITE_USE_ID, S.CUST_ACCOUNT_ID 
from          HZ_CUST_SITE_USES_ALL SU
INNER JOIN    HZ_CUST_ACCT_SITES_ALL S
       on     SU.CUST_ACCT_SITE_ID = S.CUST_ACCT_SITE_ID
LEFT OUTER JOIN     HZ_CUSTOMER_PROFILES  SITE_PROF
       on    SITE_PROF.SITE_USE_ID = SU.SITE_USE_ID
       AND   SITE_PROF.CUST_ACCOUNT_ID = S.CUST_ACCOUNT_ID
/


-- Customer Profiles can be associated with three types of site uses
select U.SITE_USE_CODE , count(*) 
from HZ_CUST_SITE_USES_ALL  U
where U.SITE_USE_ID IN (SELECT SITE_PROF.SITE_USE_ID from HZ_CUSTOMER_PROFILES SITE_PROF)
group by U.SITE_USE_CODE 
/

/*
SITE_USE_CODE                    COUNT(*)
------------------------------ ----------
SHIP_TO                               432 
BILL_TO                               797 
STMTS                                   2 
*/

select distinct SITE_USE_CODE from HZ_CUST_SITE_USES_ALL;


/*
SITE_USE_CODE                
------------------------------
SHIP_TO                        
MARKET                         
SOLD_TO                        
LATE_CHARGE                    
INV                            
ACK                            
CREDIT_CONTACT                 
LEGAL                          
DELIVER_TO                     
INSTAL                         
DRAWEE                         
DUN                            
CM                             
BILL_TO                        
STMTS                          
BOL                            

 16 rows selected 
*/

desc HZ_CUSTOMER_PROFILES
desc HZ_CUST_SITE_USES_ALL
desc HZ_CUST_ACCT_SITES_ALL

