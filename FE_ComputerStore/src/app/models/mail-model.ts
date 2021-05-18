import { billDetailModel } from "./bill-detail-model";

export interface mailModel{
    name?: string,
    email?:string,
    address?:string,
    phone_number?:string,
    note?:string,
    created_at?:Date,
    listProduct?:billDetailModel[],
    total_money?:number
 }