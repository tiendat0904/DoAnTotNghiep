import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { ModalDismissReasons, NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { FacebookService, InitParams } from "ngx-facebook";
import { ToastrService } from 'ngx-toastr';
import { billModel } from '../../models/bill-model';
import { mailModel } from '../../models/mail-model';
import { MailService } from '../../services/mail/mail.service';
declare var $: any;

@Component({
  selector: 'app-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.scss']
})
export class UserComponent implements OnInit {

  modalReference: any;
  closeResult: string;
  formGroup: FormGroup;
  constructor(private modalService: NgbModal,private fb: FormBuilder, private toastr: ToastrService, private mailService:MailService) {
    this.formGroup = new FormGroup({
      contact_name: new FormControl(),
      contact_email: new FormControl(),
      contact_tel: new FormControl(),
      contact_message: new FormControl()
    });
  }

  ngOnInit(): void {
    // this.initFacebookService();
    this.scollPage();
    this.formGroup = this.fb.group({
      contact_name: [null, [Validators.required]],
      contact_email: [null, [Validators.required]],
      contact_tel: [null, [Validators.required]],
      contact_message: [null, [Validators.required]],
    });
  }
  // private initFacebookService(): void {
  //   const initParams: InitParams = { xfbml:true, version:'v3.2'};
  //   this.facebookService.init(initParams);
  // }

  scollPage() {
    $(window).scroll(function () {
      if ($(this).scrollTop() > 200) {
        var buttonToTop = document.getElementById("toTop");
        buttonToTop.style.display = "block";
      } else {
        var buttonToTop = document.getElementById("toTop");
        buttonToTop.style.display = "none";
      }
    }
    )
  }

  save(){
    let contact: mailModel;
    if (this.formGroup.invalid) {
      this.toastr.warning('Vui lòng nhập đầy đủ thông tin', 'www.tiendatcomputer.vn cho biết');
        return;
      }
    contact = {
      email: this.formGroup.get('contact_email')?.value,
      name: this.formGroup.get('contact_name')?.value,
      phone_number: this.formGroup.get('contact_tel')?.value,
      note : this.formGroup.get('contact_message')?.value,
    };
    this.mailService.sendcontact(contact).subscribe(data =>{
      this.toastr.success(data.success, 'www.tiendatcomputer.vn cho biết');
      this.modalReference.dismiss();
      this.formGroup = this.fb.group({
        contact_name: [null, [Validators.required]],
        contact_email: [null, [Validators.required]],
        contact_tel: [null, [Validators.required]],
        contact_message: [null, [Validators.required]],
      });
    })
  }

  onActivate(event) {
    let scrollToTop = window.setInterval(() => {
      let pos = window.pageYOffset;
      if (pos > 0) {
        window.scrollTo(0, pos - 100); 
      } else {
        window.clearInterval(scrollToTop);
      }
    }, 16);
  }

  open(content: any) {
    this.modalReference = this.modalService.open(content, {
      ariaLabelledBy: 'modal-basic-title',
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
}
