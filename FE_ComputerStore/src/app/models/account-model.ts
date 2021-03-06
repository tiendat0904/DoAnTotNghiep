export interface accountModel{
    account_id? : number,
    email?: string,
    password?:string,
    confirm_password?: string,
    old_password?: string,
    new_password? : string,
    full_name?: string,
    address?: string,
    phone_number?: string,
    value?: string,
    image?: string,
    account_type_id?: number,
    created_at?: Date;
    checked?:  boolean
 }