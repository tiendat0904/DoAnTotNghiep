import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateProductImageComponent } from './update-product-image.component';

describe('UpdateProductImageComponent', () => {
  let component: UpdateProductImageComponent;
  let fixture: ComponentFixture<UpdateProductImageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdateProductImageComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateProductImageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
