export interface newsModel{
    news_id?: bigint,
    title?: String,
    news_content?: Text,
    highlight?: number,
    thumbnail?: string,
    url?: String,
    created_at?: Date,
    checked?: boolean,
 }