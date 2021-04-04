import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateCouponDetailComponent } from './update-coupon-detail.component';

describe('UpdateCouponDetailComponent', () => {
  let component: UpdateCouponDetailComponent;
  let fixture: ComponentFixture<UpdateCouponDetailComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdateCouponDetailComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateCouponDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
