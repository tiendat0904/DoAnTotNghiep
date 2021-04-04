export interface accountModel{
    account_id? : bigint,
    email?: string,
    password?: string,
    old_password?: string,
    new_password? : string,
    full_name?: string,
    address?: string,
    phone_number?: string,
    value?: string,
    image?: string,
    account_type_id?: bigint,
    checked?:  boolean
 }