-- select a."Reimbursement_Sub_Type",
-- a."Bill_Amount", a."Amount_Claimed",
-- a."Claim_Date",	count(a."Claim_Date") as cnt_Date
-- /*sum(a."Amount_Claimed") as "sum_of_amt"*/ 
-- from public."demoimp" a
-- where a."Reimbursement_Sub_Type" in ('Chair','Recliner')
-- and a."Bill_Amount"="Amount_Claimed"
-- group by 1,2,3,4

select a."Reimbursement_ID",a."Reimbursement_Type",a."Bill_Amount",

Sum(a."Bill_Amount") 
over (order by a."Reimbursement_ID"
	  rows between unbounded preceding and current row) 
					as "Bill_Amt_Cum_sum",
					
a."Amount_Claimed",

sum(a."Amount_Claimed") 
over ( order by a."Reimbursement_ID" asc
	  rows between unbounded preceding and current row)
	  		as "Amt_claimed|Cum_sum/Runing_Total"

from public."demoimp" a
order by a."Reimbursement_ID"
