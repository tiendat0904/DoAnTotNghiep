import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateTrademarkComponent } from './update-trademark.component';

describe('UpdateTrademarkComponent', () => {
  let component: UpdateTrademarkComponent;
  let fixture: ComponentFixture<UpdateTrademarkComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ UpdateTrademarkComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(UpdateTrademarkComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
