import { TestBed } from '@angular/core/testing';

import { CouponDetailService } from './coupon-detail.service';

describe('CouponDetailService', () => {
  let service: CouponDetailService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CouponDetailService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
