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
    const voucher_code = 'voucher_code';
    const startDate = 'startDate';
    const endDate = "endDate";

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
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $this->base->index();
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        // } 
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
        date_default_timezone_set(BaseController::timezone);
        $date = date('Y-m-d');
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $arr_value = $request->all();
            if (count($arr_value) > 0) {
                $validator = Validator::make($arr_value, [
                    self::startDate => 'required',
                    self::endDate => 'required',
                    'voucher_level' => 'required',
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
                $startDate = strtotime($arr_value[self::startDate]);
                $ngay = date('Y-m-d', $startDate);
                $endDate = strtotime($arr_value[self::endDate]);
                $ngay = date('Y-m-d', $endDate);
                if (date('Y-m-d', $startDate) < $date || date('Y-m-d', $endDate) < $date) {
                    return response()->json(['error' => 'Ngày không hợp lệ. Ngày nhập phải lớn hơn ngày hiện tại'], 400);
                }
                if(date('Y-m-d', $startDate) > date('Y-m-d', $endDate)){
                    return response()->json(['error' => 'Ngày không hợp lệ. Ngày kết thúc phải lớn hơn ngày bắt đầu'], 400);
                }
                if ((int)$arr_value['voucher_level'] < 0 || (int)$arr_value['voucher_level'] > 100) {
                    return response()->json(['error' => 'Mức voucher không hợp lệ'], 400);
                }
            } else {
                return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            }
            $voucher = [];
            $voucher[self::startDate] = $arr_value[self::startDate];
            $voucher[self::endDate] = $arr_value[self::endDate];
            $customers = [];
            $customers = $request->listCustomer;
            DB::table(self::table)->insert($voucher);
            $ma_voucher = DB::table(self::table)->select(self::id)->orderByDesc(self::id)->first();
            foreach ($customers as $customer) {
                DB::table(VoucherCustomerController::table)
                    ->insert([
                        VoucherCustomerController::customer_id => $customer['account_id'],
                        VoucherCustomerController::voucher_id => $ma_voucher->voucher_id,
                        VoucherCustomerController::voucher_level => $arr_value['voucher_level'],
                        VoucherCustomerController::status => "Chưa sử dụng"
                    ]);
            }
            return response()->json(['success' => "Thêm mới thành công"], 201);
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
        $objs = DB::table(self::table)
        ->join(VoucherCustomerController::table, self::table . '.' . self::id, '=', VoucherCustomerController::table . '.' . VoucherCustomerController::voucher_id)
        ->select(self::table . '.*', VoucherCustomerController::table . '.' . VoucherCustomerController::voucher_level,VoucherCustomerController::table . '.' . VoucherCustomerController::customer_id)
        ->where(self::table . '.' . self::id, '=', $id)
        ->get();
        foreach($objs as $obj){
            $obj_customers = DB::table(AccountController::table)
            ->join(VoucherCustomerController::table, VoucherCustomerController::table . '.' . VoucherCustomerController::customer_id, '=', AccountController::table . '.' . AccountController::id)
                    ->select(AccountController::table . '.' . AccountController::id,AccountController::table . '.' . AccountController::full_name,AccountController::table . '.' . AccountController::email,AccountController::table . '.' . AccountController::phone_number)
                    ->where(AccountController::table . '.' . AccountController::id, '=', $obj->customer_id)
                    ->get();
            foreach($obj_customers as $obj_customer){
                $obj->listCustomer[] =  $obj_customer;
            }
                    
        }
        
        
    $code = 200;
    return response()->json(['data' => $objs], $code);
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
        // $objs = null;
        // $code = null;
        // $objs = DB::table(self::table)
        //     ->join(AccountController::table, self::table . '.' . self::customer_id, '=', AccountController::table . '.' . AccountController::id)
        //     ->select(self::table . '.*', AccountController::table . '.' . AccountController::full_name)
        //     ->where(self::table . '.' . self::customer_id, '=', $id)->get();
        // $code = 200;
        // return response()->json(['data' => $objs], $code);
        // } 
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
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
        $this->base->update($request, $id);
        return response()->json($this->base->getMessage(), $this->base->getStatus());
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        // }
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
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
        $this->base->destroy($request);
        return response()->json($this->base->getMessage(), $this->base->getStatus());
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        // }
    }
}
