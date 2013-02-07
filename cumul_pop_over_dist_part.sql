select 
  (sum(cast(weight as float)) /
  (select sum(weight) from nodes
    where scenario_id=2 and
          node_type_id=1)) weight, p.distance
  from 
  (select weight, e.distance 
    from edges e, nodes n 
    where n.node_type_id=1 and 
    e.from_node_id=n.id and
    e.scenario_id=2) pop_dist,
  (select distance from generate_series(
	    (select min(distance) from edges), 
	    (select max(distance) from edges),
	    (select (max(distance) - min(distance)) / 5 from edges)) as distance) p
  where pop_dist.distance <= p.distance
  group by p.distance
  order by p.distance
