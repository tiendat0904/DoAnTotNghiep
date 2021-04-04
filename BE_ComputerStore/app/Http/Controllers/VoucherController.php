<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class VoucherController extends Controller
{

    private $base;
    const table = 'voucher';
    const id = 'voucher_id';
    const customer_id = 'customer_id';
    const voucher_level = 'voucher_level';

    /**
     * NhaCungCapController constructor.
     * @param $base
     */
    public function __construct()
    {
        $this->base = new BaseController(self::table, self::id);
    }


    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $objs = null;
            $code = null;
            $objs = DB::table(self::table)
                ->join(AccountController::table, self::table . '.' . self::customer_id, '=', AccountController::table . '.' . AccountController::id)
                ->select(self::table . '.*', AccountController::table . '.' . AccountController::full_name)
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } 
        // else {
        //     $objs = DB::table(self::table)
        //         ->join(AccountController::table, self::table . '.' . self::customer_id, '=', AccountController::table . '.' . AccountController::id)
        //         ->select(AccountController::table . '.' . AccountController::full_name, self::voucher_level)
        //         ->where(self::table . '.' . self::customer_id, '=', $user->ma_tai_khoan)
        //         ->get();
        //     $code = 200;
        //     return response()->json(['data' => $objs], $code);
        // }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $validator = Validator::make($request->all(), [
                self::customer_id => 'required',
                self::voucher_level => 'required',
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            $this->base->store($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $objs = null;
            $code = null;
            $objs = DB::table(self::table)
                ->join(AccountController::table, self::table . '.' . self::customer_id, '=', AccountController::table . '.' . AccountController::id)
                ->select(self::table . '.*', AccountController::table . '.' . AccountController::full_name)
                ->where(self::table . '.' . self::customer_id, '=', $id)->first();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } 
        // else {
        //     $objs = DB::table(self::table)
        //         ->join(AccountController::table, self::table . '.' . self::customer_id, '=', AccountController::table . '.' . AccountController::id)
        //         ->select(AccountController::table . '.' . AccountController::full_name, self::voucher_level)
        //         ->where(self::table . '.' . self::customer_id, '=', $user->ma_tai_khoan)
        //         ->get();
        //     $code = 200;
        //     return response()->json(['data' => $objs], $code);
        // }
        
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $this->base->update($request, $id);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $this->base->destroy($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }
}
