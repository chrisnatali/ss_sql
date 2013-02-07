select sum(weight) pop, distance from (select weight, e1.distance from edges e1, edges e2, nodes n where n.node_type_id=1 and e2.from_node_id=n.id and e2.distance <= e1.distance) agg group by distance order by distance;