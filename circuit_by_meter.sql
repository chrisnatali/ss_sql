select * from 
  (select * from 
    (select 
      circuit.id,
      circuit.ip_address,
      circuit.status,
      circuit.pin,
      circuit.credit,
      account.lang, 
      meter.id meter_id
    from 
      circuit
    join
      account on (account.id=circuit.account_id) 
    join
      meter on (meter.id=circuit.meter)) bmr where meter_id=16) base_meter 
    join 
      (select * from 
        (select 
          circuit_id, 
          watthours, 
          created, 
          rank() over (partition by circuit_id order by created desc) circuit_row_num 
        from primary_log) plog_ci_rank 
      where plog_ci_rank.circuit_row_num=1) base_circuit 
    on base_meter.id=base_circuit.circuit_id;
