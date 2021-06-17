import { TestBed } from '@angular/core/testing';

import { VoucherCustomerServiceService } from './voucher-customer-service.service';

describe('VoucherCustomerServiceService', () => {
  let service: VoucherCustomerServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(VoucherCustomerServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
