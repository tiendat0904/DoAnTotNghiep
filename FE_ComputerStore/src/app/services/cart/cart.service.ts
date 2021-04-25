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
      console.log("LOCALSTORAGE NULL",JSON.parse(localStorage.getItem('cart')));
      itemsInCart.push(this.items);
      localStorage.setItem('cart', JSON.stringify(itemsInCart));
      this.subject.next('changed');
    }
    else
    {
      local_storage = JSON.parse(localStorage.getItem('cart'));
      console.log("LOCAL STORAGE HAS ITEMS",JSON.parse(localStorage.getItem('cart')));
      for(var i in local_storage)
      {
        console.log(local_storage[i].product.id);
        if(this.items.product.product_id == local_storage[i].product.product_id)
        {
          local_storage[i].quantity += 1;
          // console.log("Quantity for "+i+" : "+ local_storage[i].quantity);
          // console.log('same product! index is ', i); 
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
    // console.log("Cart: ", JSON.parse(localStorage.getItem('cart')));
    return this.items = JSON.parse(localStorage.getItem('cart'));
    //return this.items = 
  }
  
  deleteItem(item){
    item = item;
    // console.log("Deleting : ",item);
    let shopping_cart;
    let index;
    shopping_cart = JSON.parse(localStorage.getItem('cart'));
    for(let i in shopping_cart){
      if (item.product.product_name == shopping_cart[i].product.product_name)
      {
        index = i;
        // console.log(index);
      }
    }
    shopping_cart.splice(index, 1);
    // console.log("shopping_cart ", shopping_cart);
    localStorage.setItem('cart', JSON.stringify(shopping_cart));
    this.subject.next('changed');
  }

  addQty(item: ItemModel)
  {
    item = item;
    let shopping_cart;
    shopping_cart = JSON.parse(localStorage.getItem('cart'));
    for(let i in shopping_cart){
      if(item.product.product_name == shopping_cart[i].product.product_name){
        if(shopping_cart[i].quantity== 10){
          break;
        }else{
          shopping_cart[i].quantity +=1;
          item = null;
          break;
        }
      }
    }
    localStorage.setItem('cart', JSON.stringify(shopping_cart));
  }
  
  minusQty(item: ItemModel)
  {
    item = item;
    let shopping_cart;
    shopping_cart = JSON.parse(localStorage.getItem('cart'));
    for(let i in shopping_cart){
      if(item.product.product_name == shopping_cart[i].product.product_name){
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
    localStorage.clear();
  }
}
