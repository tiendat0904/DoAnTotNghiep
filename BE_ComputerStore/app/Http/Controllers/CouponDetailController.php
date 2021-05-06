<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CouponDetailController extends Controller
{
    private $base;
    const table = 'coupon_detail';
    const id = 'coupon_detail_id';
    const coupon_id = 'coupon_id';
    const product_id = 'product_id';
    const price = 'price';
    const amount = 'amount';

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
                ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
                ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name)
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
        $arr_value = $request->all();
        if (count($arr_value) > 0) {
            $validator = Validator::make($arr_value, [
                self::coupon_id => 'required',
                self::product_id => 'required',
                self::price => 'required',
                self::amount => 'required',
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            if ($arr_value[self::price] < 1) {
                return response()->json(['error' => 'Giá nhập phải lớn hơn 0'], 400);
            }
            if ($arr_value[self::amount] < 1) {
                return response()->json(['error' => 'Số lượng phải lớn hơn 0'], 400);
            }
            
            $obj = DB::table(self::table)
                ->select(self::table . '.*')
                ->where(self::product_id, '=', $arr_value[self::product_id])
                ->where(self::coupon_id, '=', $arr_value[self::coupon_id])
                ->get();
            if (count($obj) > 0) {
                return response()->json(['error' => 'Thêm mới thất bại. Sản phẩm đã có trong phiếu nhập này'], 400);
            }
            DB::table(self::table)->insert($arr_value);
            return response()->json(['success' => 'Thêm mới thành công'], 201);
        } else {
            return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
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
            ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name)
            ->where(self::table . '.' . self::id, '=', $id)->first();
        if ($objs) {
            return response()->json(['data' => $objs], 200);
        } else {
            return response()->json(['message' => "Không tìm thấy"], 200);
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
        $this->base->destroy($request);
        return response()->json($this->base->getMessage(), $this->base->getStatus());
    }
}
