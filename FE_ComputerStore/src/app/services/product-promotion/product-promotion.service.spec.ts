import { TestBed } from '@angular/core/testing';

import { ProductPromotionService } from './product-promotion.service';

describe('ProductPromotionService', () => {
  let service: ProductPromotionService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ProductPromotionService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
