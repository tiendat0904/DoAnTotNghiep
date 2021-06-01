<?php

namespace App\Http\Controllers;

use App\Mail\TestMail;
use Illuminate\Support\Facades\Mail;
use Illuminate\Http\Request;


class MailController extends Controller
{
    //
    public function sendMail(Request $request){
        $arrayProduct = [];
        $arrayProduct = $request->listProduct;
        $details = ['name'=>$request->name,'email'=>$request->email,'phone_number'=>$request->phone_number,'address'=>$request->address,'note'=>$request->note,'listProduct'=> $arrayProduct,'total_money'=> $request->total_money];
        $user['to']=$request->email;
        Mail::send('email/testMail',$details,function($messages) use ($user){
            $messages->from('tiendatcomputerstore@gmail.com');
            $messages->to($user['to']);
            $messages->subject('Đơn hàng của bạn');
        });
        return "Email send success";
    }

    public function sendContact(Request $request){
        $details = ['name'=>$request->name,'email'=>$request->email,'phone_number'=>$request->phone_number,'note'=>$request->note];
       $user['to']=$request->email;
        Mail::send('email/sendcontact',$details,function($messages) use ($user){
            $messages->from($user['to']);
            $messages->to('tiendatcomputerstore@gmail.com');
            $messages->subject('Email liên hệ');
        });
        return response()->json(['success' => "Gửi liên hệ thành công, chúng tôi sẽ trả lời email trong thời gian sớm nhất."], 200);
    }

    public function sendCode(Request $request){
        $details = ['email'=>$request->email,'code'=>$request->code];
        $user['to']=$request->email;
        Mail::send('email/sendcode',$details,function($messages) use ($user){
            $messages->from('tiendatcomputerstore@gmail.com');
            $messages->to($user['to']);
            $messages->subject('Cài lại mật khẩu');
        });
        return response()->json(['success' => "Đã gửi mã xác nhận vào email của bạn"], 201);
    }
}
