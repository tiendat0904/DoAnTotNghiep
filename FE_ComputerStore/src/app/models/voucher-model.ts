export interface voucherModel{
    voucher_id ?: number,
    customer_id?: number,
    full_name ? : string,
    voucher_level?: number,
    startDate?: Date,
    endDate?:Date;
    checked?:  boolean,
    listCustomer:any[];
    selected?: boolean
 }