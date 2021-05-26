export interface commentModel{
    comment_id ? : number,
    parentCommentId?:number,
    product_id?: number,
    account_id?: number,
    account_type_id?:number,
    full_name?:String,
    image ?:String,
    rate?:number,
    description?:string;
    checkRepComment?:boolean,
    comment_content? : Text,
    checked?:boolean;
    status?:string;
    created_at?: Date,
 }