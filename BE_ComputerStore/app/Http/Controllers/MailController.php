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
        return response()->json(['data' =>$arrayProduct], 200);
    }
}
