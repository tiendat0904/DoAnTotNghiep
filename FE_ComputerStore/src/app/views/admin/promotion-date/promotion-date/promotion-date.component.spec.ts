import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PromotionDateComponent } from './promotion-date.component';

describe('PromotionDateComponent', () => {
  let component: PromotionDateComponent;
  let fixture: ComponentFixture<PromotionDateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PromotionDateComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PromotionDateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
