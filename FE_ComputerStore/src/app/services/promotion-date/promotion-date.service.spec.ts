import { TestBed } from '@angular/core/testing';

import { PromotionDateService } from './promotion-date.service';

describe('PromotionDateService', () => {
  let service: PromotionDateService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PromotionDateService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
