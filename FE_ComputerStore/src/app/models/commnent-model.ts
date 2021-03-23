export interface commentModel{
    comment_id ? : bigint,
    product_id?: bigint,
    customer_id?: bigint,
    comment_content? : Text,
    created_at?: Date,
 }