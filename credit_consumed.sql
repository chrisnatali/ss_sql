select coalesce(sum(diff), 0) from 
  (select (first_pairs.credit - second_pairs.credit) diff from
    (select credit, ((row_number() over ()) + 1) rownum from 
      (select base.credit, base.created_seconds - base.date_seconds seconds_diff from 
        (select pl.credit, l.date, pl.created, extract(epoch from pl.created) created_seconds, extract(epoch from l.date) date_seconds from 
          log l, 
          primary_log pl 
          where l.id=pl.id and 
                l.date > (current_date - 30) and 
                l.date <= current_date and 
                pl.circuit_id=37 
          order by l.date) base
      where (base.created_seconds - base.date_seconds) < 3600) log_seconds
     ) first_pairs,
    (select credit, row_number() over () rownum from 
      (select base.credit, base.created_seconds - base.date_seconds seconds_diff from 
        (select pl.credit, l.date, pl.created, extract(epoch from pl.created) created_seconds, extract(epoch from l.date) date_seconds from 
          log l, 
          primary_log pl 
          where l.id=pl.id and 
                l.date > (current_date - 30) and 
                l.date <= current_date and 
                pl.circuit_id=37 
          order by l.date) base
      where (base.created_seconds - base.date_seconds) < 3600) log_seconds
     ) second_pairs
   where first_pairs.rownum = second_pairs.rownum) credit_diff
 where diff > 0;
