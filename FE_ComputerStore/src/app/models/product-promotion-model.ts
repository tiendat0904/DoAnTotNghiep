export interface productPromotionDModel{
    product_promotion_id?: bigint,
    product_id?: bigint,
    product_name?: string,
    promotion_date_id?: bigint,
    date?: Date,
    promotion_level? : number,
    checked?:boolean
 }