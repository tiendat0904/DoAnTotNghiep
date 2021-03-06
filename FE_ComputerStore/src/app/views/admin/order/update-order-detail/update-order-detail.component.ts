import { Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ToastrService } from 'ngx-toastr';
import { billDetailModel } from '../../../../models/bill-detail-model';
import { billModel } from '../../../../models/bill-model';
import { productModel } from '../../../../models/product-model';
import { BillDetailService } from '../../../../services/bill-detail/bill-detail.service';
import { BillService } from '../../../../services/bill/bill.service';
import { ProductService } from '../../../../services/product/product.service';

@Component({
  selector: 'app-update-order-detail',
  templateUrl: './update-order-detail.component.html',
  styleUrls: ['./update-order-detail.component.scss']
})
export class UpdateOrderDetailComponent implements OnInit {

  @ViewChild('content') public childModal!: ModalDirective;
  @Input() arraylist_bill_detail: Array<billDetailModel>;
  @Input() mess_bill : billModel;
  @Input() mess_bill1 : any;
  @Input() isAdd1 : Boolean;
  @Output() eventEmit: EventEmitter<any> = new EventEmitter<any>();
  listFilterResult: billDetailModel[] = [];
  listFilterResult1: Array<billDetailModel> = [];
  arraylist_product: Array<productModel> = [];
  arraylist_bill_detail1: Array<billDetailModel> = [];
  arraylist_bill: Array<billModel> = [];
  checkButton = false;
  closeResult: String;
  modalReference!: any;
  formGroup: FormGroup;
  isAdd = false;
  image: string = null;
  price_display:number;
  isEdit = false;
  avatarUrl;
  isEditimage=false;
  isInfo = false;
  submitted = false;
  isLoading=false;
  title = '';
  type: any;
  arrCheck = [];
  update_bill_id:any;
  model: billDetailModel;
  dem: number = 0;
  checkNumber : number = 0;
 
  constructor(
    private modalService: NgbModal,
    private toastr: ToastrService,
    private fb: FormBuilder,
    private billDetailService: BillDetailService,
    private productService: ProductService,
    private billService: BillService,
    ) {
    }

  ngOnInit(): void {
    this.submitted = false;
    this.fetcharraylist_bill_detail();
    this.fetcharraylist_product();
    this.fetcharraylist_bill();
  }

  fetcharraylist_bill_detail(){
    this.arraylist_bill_detail=[];
    this.billDetailService.getAll().subscribe(data => {
      this.arraylist_bill_detail = data.data; 
    })
  }

  fetcharraylist_bill(){
    this.arraylist_bill=[];
    this.billService.getAll().subscribe(data => {
      this.arraylist_bill = data.data;
      this.update_bill_id = this.arraylist_bill[this.arraylist_bill.length-1].bill_id;
      this.update_bill_id = this.update_bill_id+1;
    })
  }

  fetcharraylist_product(){
    this.arraylist_product=[];
    this.productService.getAll().subscribe(data => {
      this.arraylist_product = data.data;
    })
  }

  updateFormType(type: any) {
    switch (type) {
      case 'add':
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        this.title = `Th??m m???i th??ng tin chi ti???t h??a ????n`;
        break;
      case 'show':
        this.isInfo = true;
        this.isEdit = false;
        this.isAdd = false;
        this.title = `Xem chi ti???t th??ng tin chi ti???t h??a ????n `;
        break;
      case 'edit':
        this.isInfo = false;
        this.isEdit = true;
        this.isAdd = false;
        this.title = `Ch???nh s???a th??ng tin chi ti???t h??a ????n `;
        break;
      default:
        this.isInfo = false;
        this.isEdit = false;
        this.isAdd = true;
        break;
    }
  }

  changeStatus(event: any){
    this.productService.detail(event.target.value).subscribe(data => {
      if(data.data.price){
        this.price_display = data.data.price;
      }else{
        this.price_display = data.data.price_new;
      }
    })
  }

  view(model: billDetailModel, type = null): void {
    this.arrCheck = this.arraylist_bill_detail;
    this.open(this.childModal);
    this.type = type;
    this.model = model;
    this.submitted = false;
    this.updateFormType(type);
   
    if (model.bill_detail_id === null || model.bill_detail_id === undefined) {
      if(this.mess_bill1===undefined){
        this.formGroup = this.fb.group({
          bill_id: [ this.update_bill_id],
          product_id: [ null, [Validators.required]],
          amount: [ null, [Validators.required]],
          price : [],  
        });
      }else{
        this.formGroup = this.fb.group({
          bill_id: [ this.mess_bill1],
          product_id: [ null, [Validators.required]],
          amount: [ null, [Validators.required]],
          price : [],
        });
      }
    } else {
      this.formGroup = this.fb.group({
        bill_id: [{value: this.mess_bill1, disabled: this.isInfo}],
        product_id:[{value: this.model.product_id, disabled: this.isInfo}, [Validators.required]],
        amount:[{value: this.model.amount, disabled: this.isInfo}, [Validators.required]],
        price : [{value: this.model.price, disabled: this.isInfo}, [Validators.required]],
      });
      
    }
  }


  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
      centered: true,
      size: 'md',
    });
    this.modalReference.result.then(
      (result: any) => {
        this.closeResult = `Closed with: ${result}`;
      },
      (reason: any) => {
        this.closeResult = `Dismissed ${this.getDismissReason(reason)}`;
      }
    );
  }

  private getDismissReason(reason: any): string {
    if (reason === ModalDismissReasons.ESC) {
      return 'by pressing ESC';
    } else if (reason === ModalDismissReasons.BACKDROP_CLICK) {
      return 'by clicking on a backdrop';
    } else {
      return `with: ${reason}`;
    }
  }

  save() {
    
    let check = false;
    let billDetail: billDetailModel;
    this.submitted = true;
    if (this.formGroup.invalid) {
    this.toastr.error('Ki???m tra th??ng tin c??c tr?????ng ???? nh???p', 'www.tiendatcomputer.vn cho bi???t');;
      return;
    }
    
    if(this.checkNumber === 0 && this.isAdd1===true){
      this.billService.create(this.mess_bill).subscribe(res => {
      },
      err => {
        this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho bi???t');
      }
      );
    }
    if (this.isEdit) {
      billDetail = {
        bill_detail_id: this.model.bill_detail_id,
        bill_id: this.formGroup.get('bill_id')?.value,
        product_id: this.formGroup.get('product_id')?.value,
        amount: this.formGroup.get('amount')?.value,
        price : this.formGroup.get('price')?.value,
      };
     
    } else {
      billDetail = {
        bill_id: this.formGroup.get('bill_id')?.value,
        product_id: this.formGroup.get('product_id')?.value,
        amount: this.formGroup.get('amount')?.value,
        price : this.price_display
      };
    }
    if (this.isAdd) {
      this.billDetailService.create(billDetail).subscribe(res => {
        this.closeModalReloadData();
        
        this.listFilterResult=[];
        this.billDetailService.getAll().subscribe(data => {
          this.arraylist_bill_detail = data.data;
          for(let item of this.arraylist_bill_detail){
            if(item.bill_id===this.mess_bill1 || item.bill_id=== this.update_bill_id){
                this.listFilterResult.push(item);
                this.checkNumber = this.listFilterResult.length;
            }
          }
        },)
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho bi???t');
        this.modalReference.dismiss();
      },
      err => {
        this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho bi???t');
      }
      );
    }
    if (this.isEdit) {
      this.billDetailService.update(billDetail.bill_detail_id, billDetail).subscribe(res => {
        this.closeModalReloadData();
        this.toastr.success(res.success, 'www.tiendatcomputer.vn cho bi???t');
        this.modalReference.dismiss();
      },
      err => {
        this.toastr.error(err.error.error, 'www.tiendatcomputer.vn cho bi???t');
      }
      );
    }
  }

  public closeModalReloadData(): void {
    this.submitted = false;
    this.eventEmit.emit('success');
  }

}
