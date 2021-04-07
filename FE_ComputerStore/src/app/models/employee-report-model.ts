export interface employeeReportModel{
    account_id? : bigint,
    email?: string,
    full_name?: string,
    address? : string,
    phone_number? : string,
    account_type_description?: string,
    total_money?: number,
    created_at?: Date, 
    image?: string,
    checked?:  boolean
 }