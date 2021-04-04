export interface billDetailModel{
    bill_detail_id? : bigint,
    bill_id?: bigint,
    product_id?: bigint,
    product_name?: string,
    price? : number,
    amount?: number,
    checked?: boolean
 }