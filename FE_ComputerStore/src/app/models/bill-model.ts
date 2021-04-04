export interface billModel{
    bill_id? : bigint,
    employee_id?: bigint,
    employee_name?: string,
    customer_name?:string,
    customer_id?: bigint,
    order_type_id? : bigint,
    order_status_id?: bigint,
    created_at?: Date,
    total_money?: number,
    into_money?: number,
    checked?: boolean,
 }