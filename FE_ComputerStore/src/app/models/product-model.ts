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
    price_display?:number;
    amount?: number,
    image?: string,
    checked?: boolean,
    check?:string,
    isCheckPrice ?: boolean
 }