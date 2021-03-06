export interface productModel{
    product_id?: number,
    product_name?: String,
    trademark_id?: bigint,
    trademark_name?:String,
    product_type_name?: String,
    product_type_id?: bigint,
    description? : String,
    view?: number,
    descriptions?:any[];
    price?: number,
    price_new?: number,
    countComment?:number,
    price_display?:number,
    warranty?: number,
    amount?: number,
    image?: any[],
    checked?: boolean,
    check?:string,
    checkAmount?:boolean,
    isCheckPrice ?: boolean
 }