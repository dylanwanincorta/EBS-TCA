SELECT r.cust_account_role_id,
  p.party_type
FROM hz_cust_account_roles r
INNER JOIN hz_parties p
ON r.party_id = p.party_id
WHERE rownum  < 10 ;
SELECT * FROM all_views WHERE view_name LIKE 'ARH%';
SELECT t.trx_number,
  r.party_id
FROM ra_Customer_trx_all t
INNER JOIN hz_cust_account_roles r
ON r.cust_account_role_id = t.bill_to_contact_id
WHERE rownum              < 10;
-- all bill_to_contact_id are IN
SELECT t.trx_number
FROM ra_Customer_trx_all t
WHERE t.bill_to_contact_id NOT IN
  (SELECT r.cust_account_role_id FROM hz_cust_account_roles r
  )
AND rownum < 10;
SELECT *
FROM hz_relationships rel
WHERE rownum  < 10
AND party_id IS NOT NULL
/
SELECT DISTINCT rel1.relationship_code,
  rel1.DIRECTIONAL_FLAG
FROM hz_cust_account_roles r
INNER JOIN hz_relationships rel1
ON r.party_id         = rel1.party_id
WHERE r.party_id NOT IN
  (SELECT party_id
  FROM hz_relationships rel
  WHERE subject_type   = 'PERSON'
  AND DIRECTIONAL_FLAG = 'F'
  )
AND rownum <10
/
SELECT p.party_type,
  COUNT(*)
FROM hz_cust_account_roles r1
INNER JOIN hz_parties p
ON r1.party_id                     = p.party_id
WHERE r1.cust_account_role_id NOT IN
  (SELECT r.cust_account_role_id
  FROM hz_cust_account_roles r
  INNER JOIN hz_relationships rel1
  ON r.party_id             = rel1.party_id
  AND rel1.subject_type     = 'PERSON'
  AND rel1.DIRECTIONAL_FLAG = 'F'
  INNER JOIN hz_parties c
  ON c.party_id  = rel1.subject_id
  AND party_type = 'PERSON'
  )
GROUP BY p.party_type
/
SELECT pp.party_type
FROM hz_parties pp
INNER JOIN
  (SELECT r.cust_Account_role_id,
    COALESCE(rel.subject_id, r.party_id) contact_person_party_id
  FROM hz_cust_account_roles r
  LEFT OUTER JOIN hz_relationships rel
  ON r.party_id            = rel.party_id
  AND rel.subject_type     = 'PERSON'
  AND rel.DIRECTIONAL_FLAG = 'F'
  ) RR ON pp.party_id      = rr.contact_person_party_id
WHERE pp.party_type       <> 'PERSON'
/
SELECT DISTINCT relationship_code
FROM hz_relationships rel
WHERE rel.party_id IN
  (SELECT r.party_id FROM hz_cust_account_roles r
  )
AND subject_type = 'PERSON'
AND rownum       <10
/
SELECT * FROM hz_org_contacts WHERE rownum < 10 /
SELECT r.cust_Account_role_id ,
  COALESCE(rel.subject_id, r.party_id) contact_person_party_id ,
  rel.relationship_id
FROM hz_cust_account_roles r
LEFT OUTER JOIN hz_relationships rel
ON r.party_id            = rel.party_id
AND rel.subject_type     = 'PERSON'
AND rel.DIRECTIONAL_FLAG = 'F'
WHERE rownum             < 100
/


SELECT R."CUST_ACCOUNT_ROLE_ID",
--  "PARTY_ID",
  R."CUST_ACCOUNT_ID",
  R."CURRENT_ROLE_STATE",
  R."CURRENT_ROLE_STATE_EFFECTIVE",
  R."CUST_ACCT_SITE_ID",
  R."BEGIN_DATE",
  R."END_DATE",
  R."PRIMARY_FLAG",
  R."ROLE_TYPE",
  R."LAST_UPDATE_DATE" ACCT_ROLE_LAST_UPDATE_DATE,
  R."SOURCE_CODE",
  R."LAST_UPDATED_BY"  ACCT_ROLE_LAST_UPDATED_BY,
  R."CREATION_DATE"    ACCT_ROLE_CREATION_DATE,
  R."CREATED_BY"       ACCT_ROLE_CREATED_BY,
  R."LAST_UPDATE_LOGIN",
--  R."WH_UPDATE_DATE",
--  R."REQUEST_ID",
--  R."PROGRAM_APPLICATION_ID",
--  R."PROGRAM_ID",
--  R."PROGRAM_UPDATE_DATE",
  R."ORIG_SYSTEM_REFERENCE",
  R."STATUS",
  R."OBJECT_VERSION_NUMBER",
  R."CREATED_BY_MODULE",
  R."APPLICATION_ID", 
  COALESCE(rel.subject_id, r.party_id)  contact_person_party_id ,
  rel.relationship_id ,
  rel.LAST_UPDATE_DATE     REL_LAST_UPDATE_DATE
FROM "AR"."HZ_CUST_ACCOUNT_ROLES" R
LEFT OUTER JOIN AR.hz_relationships rel
ON r.party_id            = rel.party_id
AND rel.subject_type     = 'PERSON'
AND rel.DIRECTIONAL_FLAG = 'F'
/

select count(*) from hz_cust_Account_roles;