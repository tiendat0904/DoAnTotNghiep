export interface billReportModel{
    bill_id? : bigint,
    order_status_description?: string,
    order_type_description? : string,
    into_money?: number,
    created_at?: Date,
    checked?:  boolean
 }