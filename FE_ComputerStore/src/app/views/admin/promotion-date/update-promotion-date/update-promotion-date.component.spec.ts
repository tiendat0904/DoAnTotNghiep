import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdatePromotionDateComponent } from './update-promotion-date.component';

describe('UpdatePromotionDateComponent', () => {
  let component: UpdatePromotionDateComponent;
  let fixture: ComponentFixture<UpdatePromotionDateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdatePromotionDateComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdatePromotionDateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
