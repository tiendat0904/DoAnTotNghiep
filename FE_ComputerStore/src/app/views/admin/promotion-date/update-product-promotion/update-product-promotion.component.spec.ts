import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateProductPromotionComponent } from './update-product-promotion.component';

describe('UpdateProductPromotionComponent', () => {
  let component: UpdateProductPromotionComponent;
  let fixture: ComponentFixture<UpdateProductPromotionComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdateProductPromotionComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateProductPromotionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
