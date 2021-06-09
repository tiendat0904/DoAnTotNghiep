<?php

namespace App\Http\Controllers;

use App\Models\Bill;
use App\Models\Status;
use DateTime;
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
    const name = 'name';
    const email = 'email';
    const address = 'address';
    const phone_number = 'phone_number';
    const note = 'note';
    const order_status_id = 'order_status_id';
    const total_money = 'total_money';
    const into_money = 'into_money';
    const created_at = 'created_at';
    const updatedDate = "updatedDate";

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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $objs = null;
            $code = null;
            $objs = DB::table(self::table)
                ->leftJoin(AccountConTroller::table . ' as emp', self::table . '.' . self::employee_id, '=', 'emp.' . AccountConTroller::id)
                ->leftJoin(AccountConTroller::table . ' as cus', self::table . '.' . self::customer_id, '=', 'cus.' . AccountConTroller::id)
                ->leftjoin(OrderStatusController::table, self::table . '.' . self::order_status_id, '=', OrderStatusController::table . '.' . OrderStatusController::id)
                ->leftjoin(OrderTypeController::table, self::table . '.' . self::order_type_id, '=', OrderTypeController::table . '.' . OrderTypeController::id)
                ->select(self::table . '.*', OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', 'emp.' . AccountConTroller::full_name . ' as employee_name', 'cus.' . AccountConTroller::full_name . ' as customer_name')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }


    public function getBill()
    {
        $objs = null;
        $code = null;
        $objs = DB::table(self::table)
            ->leftJoin(AccountConTroller::table . ' as emp', self::table . '.' . self::employee_id, '=', 'emp.' . AccountConTroller::id)
            ->leftJoin(AccountConTroller::table . ' as cus', self::table . '.' . self::customer_id, '=', 'cus.' . AccountConTroller::id)
            ->leftjoin(OrderStatusController::table, self::table . '.' . self::order_status_id, '=', OrderStatusController::table . '.' . OrderStatusController::id)
            ->leftjoin(OrderTypeController::table, self::table . '.' . self::order_type_id, '=', OrderTypeController::table . '.' . OrderTypeController::id)
            ->select(self::table . '.*', OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', 'emp.' . AccountConTroller::full_name . ' as employee_name', 'cus.' . AccountConTroller::full_name . ' as customer_name')
            ->orderByDesc(self::id)
            ->first();
        $code = 200;
        return response()->json(['data' => $objs], $code);
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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $validator = Validator::make($request->all(), [
                self::customer_id => 'required'
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            date_default_timezone_set(BaseController::timezone);
            $arr_value = [];
            if ($request->customer_id) {
                $arr_value[self::customer_id] = $request->customer_id;
            }
            if ($request->name) {
                $arr_value[self::name] = $request->name;
            }
            if ($request->email) {
                $arr_value[self::email] = $request->email;
            }
            if ($request->address) {
                $arr_value[self::address] = $request->address;
            }
            if ($request->note) {
                $arr_value[self::note] = $request->note;
            }

            if ($request->employee_id) {
                $arr_value[self::employee_id] = $request->employee_id;
            }
            $arr_value[self::order_status_id] = 1;
            $arr_value[self::created_at] = date('Y-m-d h:i:s');
            DB::table(self::table)->insert($arr_value);
            $objs = null;
            $objs = DB::table(self::table)
                ->where(self::table . '.' . self::customer_id, "=", $arr_value[self::customer_id])
                ->where(self::table . '.' . self::order_status_id, "=", $arr_value[self::order_status_id])->get();
            return response()->json(['success' => "Thêm mới thành công", "data" => $objs], 201);
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    public function storenotaccount(Request $request)
    {
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
        //     $validator = Validator::make($request->all(), [
        //         self::customer_id => 'required'
        //     ]);
        //     if ($validator->fails()) {
        //         return response()->json(['error' => $validator->errors()->all()], 400);
        //     }
        //     date_default_timezone_set(BaseController::timezone);
        //     $arr_value = [];
        //     if ($request->customer_id) {
        //         $arr_value[self::customer_id] = $request->customer_id;
        //     }
        //     if ($request->name) {
        //         $arr_value[self::name] = $request->name;
        //     }
        //     if ($request->address) {
        //         $arr_value[self::address] = $request->address;
        //     }
        //     if ($request->note) {
        //         $arr_value[self::note] = $request->note;
        //     }

        //     if ($request->employee_id) {
        //         $arr_value[self::employee_id] = $request->employee_id;
        //     }
        //     $arr_value[self::order_status_id] = 1;
        //     $arr_value[self::created_at] = date('Y-m-d h:i:s');
        //     DB::table(self::table)->insert($arr_value);
        //     $objs = null;
        //     $objs = DB::table(self::table)
        //         ->where(self::table . '.' .self::customer_id,"=", $arr_value[self::customer_id])
        //         ->where(self::table . '.' .self::order_status_id,"=", $arr_value[self::order_status_id])->get();
        //     return response()->json(['success' => "Thêm mới thành công","data"=>$objs], 201);
        // } else {
        // $validator = Validator::make($request->all(), [
        //     // self::customer_id => 'required'
        // ]);
        // if ($validator->fails()) {
        //     return response()->json(['error' => $validator->errors()->all()], 400);
        // }
        date_default_timezone_set(BaseController::timezone);
        $arr_value = [];
        if ($request->customer_id) {
            $arr_value[self::customer_id] = $request->customer_id;
        }
        if ($request->order_type_id) {
            $arr_value[self::order_type_id] = $request->order_type_id;
        }
        if ($request->name) {
            $arr_value[self::name] = $request->name;
        }
        if ($request->email) {
            $arr_value[self::email] = $request->email;
        }
        if ($request->address) {
            $arr_value[self::address] = $request->address;
        }
        if ($request->note) {
            $arr_value[self::note] = $request->note;
        }
        if ($request->phone_number) {
            $arr_value[self::phone_number] = $request->phone_number;
        }
        $arr_value[self::order_status_id] = 2;
        $arr_value[self::created_at] = date('Y-m-d h:i:s');
        DB::table(self::table)->insert($arr_value);
        $objs = null;
        $objs = DB::table(self::table)->orderByDesc(self::id)->first();
        return response()->json(['success' => "Thêm mới thành công", "data" => $objs], 201);
        // }
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
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $objs = DB::table(self::table)
                ->leftJoin(AccountConTroller::table . ' as emp', self::table . '.' . self::employee_id, '=', 'emp.' . AccountConTroller::id)
                ->leftJoin(AccountConTroller::table . ' as cus', self::table . '.' . self::customer_id, '=', 'cus.' . AccountConTroller::id)
                ->select(self::table . '.*', 'emp.' . AccountConTroller::full_name . ' as employee_name', 'cus.' . AccountConTroller::full_name . ' as customer_name', 'cus.' . AccountConTroller::address . ' as customer_address', 'cus.' . AccountConTroller::phone_number . ' as customer_phone_number')
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

    public function showbyaccount($id)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $objs = DB::table(self::table)
                ->leftJoin(AccountConTroller::table . ' as emp', self::table . '.' . self::employee_id, '=', 'emp.' . AccountConTroller::id)
                ->leftJoin(AccountConTroller::table . ' as cus', self::table . '.' . self::customer_id, '=', 'cus.' . AccountConTroller::id)
                ->select(self::table . '.*', 'emp.' . AccountConTroller::full_name . ' as employee_name', 'cus.' . AccountConTroller::full_name . ' as customer_name')
                ->where(self::table . '.' . self::customer_id, '=', $id)->get();

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
        date_default_timezone_set(BaseController::timezone);
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        // $ac_id = $user->account_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $arr_value = $request->all();
            $arr_value[self::updatedDate] = date('Y-m-d h:i:s');
            if (DB::table(self::table)->where(self::id, '=', $id)->update($arr_value)) {
                $obj = DB::table(self::table)->where(self::id, '=', $id)->get();
                $this->message = ['success' => "Chỉnh sửa thành công", 'data' => $obj];
                $this->status = 201;
            } else {
                $this->message = ['error' => "Chỉnh sửa thất bại"];
                $this->status = 400;
            }
        } else {
            $this->base->update($request, $id);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        }
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
        // if ($hd->order_status_id == 1 && $request->get(self::order_status_id) == 2) {
        // DB::table(self::table)->where(self::id, '=', $id)->update([self::order_status_id => true]);
        // return response()->json(['success' => 'Cập nhật thành công'], 201);
        // } else {
        //     return response()->json(['error' => 'Cập nhật thất bại'], 400);
        // }
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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            try {
                if ($listId = $request->get(BaseController::listId)) {
                    DB::table(BillDetailController::table)->where(BillDetailController::bill_id, $listId)
                        ->delete();
                    // return response()->json(['error' => 'Không tìm thấy1'], 200);
                } else {
                    $id = $request->get(BaseController::key_id);
                    DB::table(BillDetailController::table)->where(BillDetailController::bill_id, $id)
                        ->delete();
                    // return response()->json(['error' => 'Không tìm thấy'], 200);
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
