import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';
import { ItemModel } from '../../models/item-model';
import { productModel } from '../../models/product-model';

@Injectable({
  providedIn: 'root'
})
export class PcService {

  product: productModel;
  items: ItemModel;
  subject = new Subject<any>();
  constructor() { }

  addToCart(product: productModel){
    let local_storage;
    let itemsInCart = []
    this.items = {
      product: product,
      quantity: 1,
    }
    if(localStorage.getItem('PC')  == null){
      local_storage =[];
      itemsInCart.push(this.items);
      localStorage.setItem('PC', JSON.stringify(itemsInCart));
      this.subject.next('changed');
    }
    else
    {
      local_storage = JSON.parse(localStorage.getItem('PC'));
      for(var i in local_storage)
      {
        if(this.items.product.product_id == local_storage[i].product.product_id)
        {
          local_storage[i].quantity += 1;
          this.items=null;
          break;  
        }
    }
    if(this.items){
      itemsInCart.push(this.items);
    }
    local_storage.forEach(function (item){
      itemsInCart.push(item);
    })
    localStorage.setItem('PC', JSON.stringify(itemsInCart));
    this.subject.next('changed');
    }
  }

  getItems(){
    return this.items = JSON.parse(localStorage.getItem('PC'));
  }
  
  deleteItem(item){
    let shopping_PC;
    let index;
    shopping_PC = JSON.parse(localStorage.getItem('PC'));
    for(let i in shopping_PC){
      if (item == shopping_PC[i].product.product_id)
      {
        index = i;
      }
    }
    shopping_PC.splice(index, 1);
    localStorage.setItem('PC', JSON.stringify(shopping_PC));
    this.subject.next('changed');
  }

  addQty(item)
  {
    // item = item;
    let shopping_PC;
    shopping_PC = JSON.parse(localStorage.getItem('PC'));
    for(let i in shopping_PC){
      if(item == shopping_PC[i].product.product_id){
        if(shopping_PC[i].quantity == 10){
          break;
        }else{
          shopping_PC[i].quantity +=1;
          // item = null;
          break;
        }
      }
    }
    localStorage.setItem('PC', JSON.stringify(shopping_PC));
  }
  
  minusQty(item)
  {
    // item = item;
    let shopping_PC;
    shopping_PC = JSON.parse(localStorage.getItem('PC'));
    for(let i in shopping_PC){
      if(item == shopping_PC[i].product.product_id){
        if(shopping_PC[i].quantity== 1){
          break;
        }else{
          shopping_PC[i].quantity -=1;
          item = null;
          break;
        }      
      }
    }
    localStorage.setItem('PC', JSON.stringify(shopping_PC));
  }

  clearCart(){
    localStorage.removeItem('PC');
  }
}
