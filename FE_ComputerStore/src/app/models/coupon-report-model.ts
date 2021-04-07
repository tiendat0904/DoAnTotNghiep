export interface couponReportModel{
    coupon_id? : bigint,
    employee_id?: bigint,
    supplier_id?: bigint,
    employee_name? :string,
    supplier_name?: string,
    note? : Text,
    total_money? : number,
    created_at?: Date,
    checked?:  boolean
 }