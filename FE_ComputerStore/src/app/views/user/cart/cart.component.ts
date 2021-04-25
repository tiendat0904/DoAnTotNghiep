import { Component, OnInit } from '@angular/core';
import { ItemModel } from '../../../models/item-model';
import { productModel } from '../../../models/product-model';
import { CartService } from '../../../services/cart/cart.service';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.scss']
})
export class CartComponent implements OnInit {

  list_product: Array<ItemModel> = [];
  total = 0;
  constructor(private cartService:CartService) { }

  ngOnInit(): void {
    this.list_product=this.cartService.getItems(); 
    console.log(this.list_product);
    this.totalCart();
  }

  totalCart(){
    this.total = 0;
    this.list_product=this.cartService.getItems();
    for(let i of this.list_product){
      this.total+=i.quantity*i.product.price_new;
      console.log(this.total);
    }

  }

  deletecart(){
    this.cartService.clearCart();
    this.totalCart();
  }

  deleteItem(item:ItemModel){
    this.cartService.deleteItem(item);
    this.totalCart();
  }

  addQuantity(item:ItemModel){
    this.cartService.addQty(item);
    this.totalCart();
  }

  minusQuantity(item:ItemModel){
    this.cartService.minusQty(item);
    this.totalCart();
  }

}
