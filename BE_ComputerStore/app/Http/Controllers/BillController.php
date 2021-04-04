<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class BillController extends Controller
{
    private $base;
    const table = 'bill';
    const id = 'bill_id';
    const employee_id = 'employee_id';
    const customer_id = 'customer_id';
    const order_type_id = 'order_type_id';
    const order_status_id = 'order_status_id';
    const total_money = 'total_money';
    const into_money = 'into_money';
    const created_at = 'created_at';

    /**
     * AccountController constructor.
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
                ->leftJoin(AccountConTroller::table . ' as emp', self::table . '.' . self::employee_id, '=', 'emp.' . AccountConTroller::id)
                ->leftJoin(AccountConTroller::table . ' as cus', self::table . '.' . self::customer_id, '=', 'cus.' . AccountConTroller::id)
                ->select(self::table . '.*', 'emp.' . AccountConTroller::full_name . ' as employee_name', 'cus.' . AccountConTroller::full_name . ' as customer_name')
                ->get();
            $code = 200;

            return response()->json(['data' => $objs], $code);
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
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
            date_default_timezone_set(BaseController::timezone);
            $arr_value = [];
            $arr_value[self::employee_id] = $request->customer_id;
            if ($request->customer_id) {
                $arr_value[self::customer_id] = $request->customer_id;
            }
            $arr_value[self::order_type_id] = 1;
            $arr_value[self::order_status_id] = 2;
            $arr_value[self::created_at] = date('Y-m-d');
            DB::table(self::table)->insert($arr_value);
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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $objs = DB::table(self::table)
                ->Join(AccountConTroller::table . ' as emp', self::table . '.' . self::employee_id, '=', 'emp.' . AccountConTroller::id)
                ->Join(AccountConTroller::table . ' as cus', self::table . '.' . self::customer_id, '=', 'cus.' . AccountConTroller::id)
                ->select(self::table . '.*', 'emp.' . AccountConTroller::full_name . ' as employee_name', 'cus.' . AccountConTroller::full_name . ' as customer_name')
                ->where(self::table . '.' . self::id, '=', $id)->first();

    //            $listBillDetail = DB::table(BillDetailController::table)
    //                ->join(SanPhamController::table, BillDetailController::table . '.' . BillDetailController::ma_san_pham, '=', SanPhamController::table . '.' . SanPhamController::id)
    //                ->select(BillDetailController::table . '.*', SanPhamController::table . '.' . SanPhamController::ten_san_pham)
    //                ->where(BillDetailController::ma_hoa_don, '=', $id)
    //                ->get();
            if ($objs) {
                return response()->json(['data' => $objs], 200);
            } else {
                return response()->json(['error' => 'Không tìm thấy'], 200);
            }
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
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
            $hd = DB::table(self::table)->where(self::id, '=', $id)->first();
            // if ($hd->order_status_id == 1 && $request->get(self::order_status_id) == 2) {
                DB::table(self::table)->where(self::id, '=', $id)->update([self::order_status_id => true]);
                return response()->json(['success' => 'Cập nhật thành công'], 201);
            // } else {
            //     return response()->json(['error' => 'Cập nhật thất bại'], 400);
            // }
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
            try {
                if ($listId = $request->get(BaseController::listId)) {
                    DB::table(BillDetailController::table)->whereIn(BillDetailController::bill_id, $listId)
                        ->delete();    
                } else {
                    $id = $request->get(BaseController::key_id);
                    DB::table(BillDetailController::table)->whereIn(BillDetailController::bill_id, $id)
                        ->delete();
                }
            } catch (\Throwable $e) {
                report($e);
            }
            $this->base->destroy($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }
}
