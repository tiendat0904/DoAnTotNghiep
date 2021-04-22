export interface couponModel{
    coupon_id?: number,
    employee_id?: bigint,
    supplier_id?: bigint,
    total_money?: number,
    employee_name ? : string,
    supplier_name ?: string,
    note?: Text,
    created_at?: Date,
    checked? : boolean,
 }