export interface productModel{
    product_id?: number,
    product_name?: String,
    trademark_id?: bigint,
    trademark_name?:String,
    product_type_name?: String,
    product_type_id?: bigint,
    description? : String,
    price?: number,
    price_new?: number,
    price_display?:number,
    warranty?: number,
    amount?: number,
    image?: any[],
    checked?: boolean,
    check?:string,
    isCheckPrice ?: boolean
 }