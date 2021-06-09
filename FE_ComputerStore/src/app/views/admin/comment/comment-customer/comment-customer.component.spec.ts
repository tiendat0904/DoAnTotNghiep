import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CommentCustomerComponent } from './comment-customer.component';

describe('CommentCustomerComponent', () => {
  let component: CommentCustomerComponent;
  let fixture: ComponentFixture<CommentCustomerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CommentCustomerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CommentCustomerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
