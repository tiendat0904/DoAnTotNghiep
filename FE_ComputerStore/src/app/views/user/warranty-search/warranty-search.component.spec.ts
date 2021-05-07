import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WarrantySearchComponent } from './warranty-search.component';

describe('WarrantySearchComponent', () => {
  let component: WarrantySearchComponent;
  let fixture: ComponentFixture<WarrantySearchComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WarrantySearchComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WarrantySearchComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
