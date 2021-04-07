export interface iventoryReportModel{
    product_id? : bigint,
    trademark_id?: number,
    product_type_id?: number,
    product_name? : string,
    trademark_name? : string,
    product_type_name?: string,
    price?: number,
    amount?: number, 
    image?: string,
 }