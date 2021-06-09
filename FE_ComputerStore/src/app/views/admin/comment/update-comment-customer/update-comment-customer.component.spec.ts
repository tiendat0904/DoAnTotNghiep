import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateCommentCustomerComponent } from './update-comment-customer.component';

describe('UpdateCommentCustomerComponent', () => {
  let component: UpdateCommentCustomerComponent;
  let fixture: ComponentFixture<UpdateCommentCustomerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdateCommentCustomerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateCommentCustomerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
