import { couponDetailModel } from "./coupon-detail-model";

export interface couponModel{
    coupon_id?: number,
    coupon_code?: string,
    employee_id?: bigint,
    supplier_id?: bigint,
    total_money?: number,
    employee_name ? : string,
    supplier_name ?: string,
    note?: Text,
    created_at?: Date,
    checked? : boolean,
    listCouponDetail?: couponDetailModel[];
 }