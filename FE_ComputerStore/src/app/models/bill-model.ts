export interface billModel{
    bill_id? : bigint,
    employee_id?: bigint,
    employee_name?: string,
    customer_name?:string,
    customer_id?: number,
    order_status_id?: number,
    order_type_id? : number,
    created_at?: Date,
    email?: string,
    name?:string,
    address?:string,
    phone_number?:string,
    note?:string,
    total_money?: number,
    into_money?: number,
    checked?: boolean,
    check_order_status?: boolean;
 }