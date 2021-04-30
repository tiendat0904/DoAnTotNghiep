import { Injectable } from '@angular/core';
import { Toast } from 'ngx-toastr';
import { Subject,Observable } from 'rxjs';
import { ItemModel } from '../../models/item-model';
import { productModel } from '../../models/product-model';


let itemsInCart = [];
@Injectable({
  providedIn: 'root'
})
export class CartService {

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
    if(localStorage.getItem('cart')  == null){
      local_storage =[];
      itemsInCart.push(this.items);
      localStorage.setItem('cart', JSON.stringify(itemsInCart));
      this.subject.next('changed');
    }
    else
    {
      local_storage = JSON.parse(localStorage.getItem('cart'));
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
    localStorage.setItem('cart', JSON.stringify(itemsInCart));
    this.subject.next('changed');
    }
  }

  getItems(){
    return this.items = JSON.parse(localStorage.getItem('cart'));
  }
  
  deleteItem(item){
    let shopping_cart;
    let index;
    shopping_cart = JSON.parse(localStorage.getItem('cart'));
    for(let i in shopping_cart){
      if (item == shopping_cart[i].product.product_id)
      {
        index = i;
      }
    }
    shopping_cart.splice(index, 1);
    localStorage.setItem('cart', JSON.stringify(shopping_cart));
    this.subject.next('changed');
  }

  addQty(item)
  {
    // item = item;
    let shopping_cart;
    shopping_cart = JSON.parse(localStorage.getItem('cart'));
    for(let i in shopping_cart){
      if(item == shopping_cart[i].product.product_id){
        if(shopping_cart[i].quantity == 10){
          break;
        }else{
          shopping_cart[i].quantity +=1;
          // item = null;
          break;
        }
      }
    }
    localStorage.setItem('cart', JSON.stringify(shopping_cart));
  }
  
  minusQty(item)
  {
    // item = item;
    let shopping_cart;
    shopping_cart = JSON.parse(localStorage.getItem('cart'));
    for(let i in shopping_cart){
      if(item == shopping_cart[i].product.product_id){
        if(shopping_cart[i].quantity== 1){
          break;
        }else{
          shopping_cart[i].quantity -=1;
          item = null;
          break;
        }      
      }
    }
    localStorage.setItem('cart', JSON.stringify(shopping_cart));
  }

  clearCart(){
    localStorage.removeItem('cart');
  }
}
