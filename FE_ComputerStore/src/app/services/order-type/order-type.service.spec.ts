import { TestBed } from '@angular/core/testing';

import { OrderTypeService } from './order-type.service';

describe('OrderTypeService', () => {
  let service: OrderTypeService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(OrderTypeService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
