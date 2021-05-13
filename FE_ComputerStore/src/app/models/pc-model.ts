export interface BuildPCModel{
    build_pc_id ?: bigint,
    customer_id?: number,
    product_id?: number,
    image?:number,
    product_type_name?:string,
    product_name?:string,
    warranty?:number,
    price?:number,
    quantity?: number
}