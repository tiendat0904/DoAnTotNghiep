export interface couponModel{
    coupon_id?: bigint,
    employee_id?: bigint,
    supplier_id?: bigint,
    total_money?: number,
    note?: Text,
    created_at?: Date
 }