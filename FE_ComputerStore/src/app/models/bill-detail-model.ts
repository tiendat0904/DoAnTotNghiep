export interface billDetailModel{
    bill_detail_id? : number,
    bill_id?: bigint,
    product_id?: number,
    product_name?: String,
    price? : number,
    image?:string,
    amount?: number,
    warranty?:number,
    order_status_id?: number,
    checked?: boolean
 }