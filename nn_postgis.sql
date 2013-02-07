select * into nn_tmp from (
  with pop_fac_dist as 
    (select (pop.point <-> fac.point) dist, pop.id pop_id, fac.id fac_id from nodes pop, nodes fac where pop.node_type_id=1 and fac.node_type_id=2 and pop.scenario_id=5 and fac.scenario_id=5) 
  select distinct agg.dist, agg.pop_id, pop_fac.fac_id from 
    (select min(dist) dist, pop_id from pop_fac_dist group by pop_id) agg, 
    (select * from pop_fac_dist) pop_fac 
  where agg.pop_id=pop_fac.pop_id and agg.dist=pop_fac.dist) a;
