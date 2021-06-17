export interface voucherCustomerModel{
    voucher_id ?: number,
    voucher_customer_id?: number,
    voucher_level?: number,
    startDate?: Date,
    endDate?:Date;
    checked?:  boolean,
    status?: string,
    selected?: boolean
 }