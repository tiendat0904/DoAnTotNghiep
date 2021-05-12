import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SelectItemBuildPcComponent } from './select-item-build-pc.component';

describe('SelectItemBuildPcComponent', () => {
  let component: SelectItemBuildPcComponent;
  let fixture: ComponentFixture<SelectItemBuildPcComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SelectItemBuildPcComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SelectItemBuildPcComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
