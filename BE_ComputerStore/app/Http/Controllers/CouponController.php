<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CouponController extends Controller
{
    private $base;
    const table = 'coupon';
    const id = 'coupon_id';
    const employee_id = 'employee_id';
    const supplier_id = 'supplier_id';
    const note = 'note';
    const coupon_code = 'coupon_code';
    const total_money = 'total_money';
    const created_at = 'created_at';
    const updatedBy = 'updatedBy';
    const updatedDate = 'updatedDate';

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
                ->join(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', self::table . '.' . self::supplier_id)
                ->join(AccountController::table, self::table . '.' . self::employee_id, '=', AccountController::table . '.' . AccountController::id)
                ->select(self::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
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
            $validator = Validator::make($request->all(), [
                self::supplier_id => 'required',
                self::employee_id => 'required'
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            $obj = [];
            $obj[self::supplier_id] = $request->supplier_id;
            $obj[self::coupon_code] = $request->coupon_code;
            $data = DB::table(self::table)->where(self::coupon_code, '=', $request->coupon_code)->get();
            if (count($data) > 0) {
                return response()->json(['error' => 'Mã phiếu nhập của nhà cung cấp đã tồn tại'], 400);
            }
            $obj[self::employee_id] = $request->employee_id;
            $obj[self::created_at] = date('Y-m-d h:i:s');
            if ($request->note) {
                $obj[self::note] = $request->note;
            }
            DB::table(self::table)->insert($obj);
            $coupon_id = DB::table(CouponController::table)->select(CouponController::table . '.' . CouponController::id)->orderByDesc(CouponController::id)->first();
            $listCouponDetails = [];
            $listCouponDetails = $request->listCouponDetail;
            foreach ($listCouponDetails as $listCouponDetail) {
                DB::table(CouponDetailController::table)
                    ->insert([
                        CouponDetailController::coupon_id => $coupon_id->coupon_id,
                        CouponDetailController::product_id => $listCouponDetail['product_id'],
                        CouponDetailController::price => $listCouponDetail['price'],
                        CouponDetailController::amount => $listCouponDetail['amount'],
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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $objs = DB::table(self::table)
                ->join(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', self::table . '.' . self::supplier_id)
                ->join(AccountController::table, self::table . '.' . self::employee_id, '=', AccountController::table . '.' . AccountController::id)
                ->select(self::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                ->where(self::table . '.' . self::id, '=', $id)->first();
            //            $listCouponDetail = DB::table(ChiTietPhieuNhapController::table)
            //                ->join(SanPhamController::table, ChiTietPhieuNhapController::table . '.' . ChiTietPhieuNhapController::ma_san_pham, '=', SanPhamController::table . '.' . SanPhamController::id)
            //                ->select(ChiTietPhieuNhapController::table . '.*', SanPhamController::table . '.' . SanPhamController::ten_san_pham)
            //                ->where(ChiTietPhieuNhapController::ma_phieu_nhap, '=', $id)
            //                ->get();
            if ($objs) {
                return response()->json([
                    'data' => $objs
                ], 200);
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
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $data = DB::table(self::table)->where(self::coupon_code, '=', $request->coupon_code)->get();
            if (count($data) > 0) {
                return response()->json(['error' => 'Cập nhật thất bại'], 400);
            }
            $obj = [];
            $obj = $request->all();
            $obj[self::updatedDate] = date('Y-m-d h:i:s');
            $obj[self::updatedBy] = $user->account_id;
            if (count($obj) == 1) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Thiếu thông tin'], 400);
            }
            DB::table(self::table)->where(self::id, $id)->update($obj);
            return response()->json(['success' => 'Chỉnh sửa thành công'], 201);
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
        try {
            if ($listId = $request->get(BaseController::listId)) {
                DB::table(CouponDetailController::table)->whereIn(CouponDetailController::coupon_id, $listId)
                    ->delete();
                // DB::table(VoucherController::table)->join(self::table, self::table . '.' . self::ma_voucher, '=', VoucherController::table . '.' . VoucherController::id)
                //     ->whereIn(self::table . '.' . self::id, $listId)
                //     ->update([BillDetailController::isActive => true]);
            } else {
                $id = $request->get(BaseController::key_id);
                DB::table(CouponDetailController::table)->where(CouponDetailController::coupon_id, $id)
                    ->delete();
                // DB::table(VoucherController::table)->join(self::table, self::table . '.' . self::ma_voucher, '=', VoucherController::table . '.' . VoucherController::id)
                //     ->where(self::table . '.' . self::id, $id)
                //     ->update([BillDetailController::isActive => true]);
            }
        } catch (\Throwable $e) {
            report($e);
        }
        $this->base->destroy($request);
        return response()->json($this->base->getMessage(), $this->base->getStatus());
    }
}
