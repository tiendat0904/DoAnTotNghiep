export interface billModel{
    bill_id? : bigint,
    employee_id?: bigint,
    customer_id?: bigint,
    order_type_id? : bigint,
    order_status_id?: bigint,
    created_at?: Date,
    total_money?: number,
    into_money?: number,
 }