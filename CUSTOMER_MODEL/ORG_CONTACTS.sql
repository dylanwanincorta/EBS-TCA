
-- no data returns.
select party_relationship_id 
from hz_org_contacts 
group by party_relationship_id 
having count(*) > 1;

-- we can use party_relationship_id to join to HZ_ORG_CONTACTS

