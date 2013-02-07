with credit_base as (
  select 
    base.circuit_id,
    base.credit, 
    base.date meter_time, 
    base.created gateway_time,
    (base.created_seconds - base.date_seconds) seconds_diff
  from 
    (select pl.circuit_id, pl.credit, l.date, pl.created, extract(epoch from pl.created) created_seconds, extract(epoch from l.date) date_seconds from 
          log l, 
          primary_log pl 
          where l.id=pl.id and 
                l.date > (current_date - 5) and 
                l.date <= current_date and
                pl.circuit_id=37
          order by l.date) base
   where (base.created_seconds - base.date_seconds) < 3600
)     
select
  first_pairs.circuit_id,
  first_pairs.credit credit_lag,
  second_pairs.credit credit,
  /*first_pairs.meter_time,
  first_pairs.gateway_time,*/
  second_pairs.meter_time,
  second_pairs.gateway_time,
  (first_pairs.credit - second_pairs.credit) credit_diff
from
  (select *, ((row_number() over ()) + 1) rownum from credit_base) first_pairs, 
  (select *, (row_number() over ()) rownum from credit_base) second_pairs
  where first_pairs.rownum = second_pairs.rownum
