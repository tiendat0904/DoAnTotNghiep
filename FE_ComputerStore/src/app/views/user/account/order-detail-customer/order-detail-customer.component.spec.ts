import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OrderDetailCustomerComponent } from './order-detail-customer.component';

describe('OrderDetailCustomerComponent', () => {
  let component: OrderDetailCustomerComponent;
  let fixture: ComponentFixture<OrderDetailCustomerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ OrderDetailCustomerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(OrderDetailCustomerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
