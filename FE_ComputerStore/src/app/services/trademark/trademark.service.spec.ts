import { TestBed } from '@angular/core/testing';

import { TrademarkService } from './trademark.service';

describe('TrademarkService', () => {
  let service: TrademarkService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TrademarkService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
