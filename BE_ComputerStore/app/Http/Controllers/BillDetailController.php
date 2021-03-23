<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class BillDetailController extends Controller
{
    private $base;
    const table = 'bill_detail';
    const id = 'bill_detail_id';
    const bill_id = 'bill_id';
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
                    self::bill_id => 'required',
                    self::product_id => 'required',
                    self::price => 'required',
                    self::amount => 'required',
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
                if ($arr_value[self::amount] < 1) {
                    return response()->json(['error' => 'Số lượng phải lớn hơn 0'], 400);
                }
                
                $data = DB::table(self::table)
                    ->select(self::table . '.*')
                    ->where(self::product_id, '=', $arr_value[self::product_id])
                    ->where(self::bill_id, '=', $arr_value[self::bill_id])
                    ->get();
                if (count($data) > 0) {
                    return response()->json(['error' => 'Thêm mới thất bại. Có 1 row đã tồn tại mã hóa đơn và mã sản phẩm'], 400);
                }
                $sl = DB::table(ProductController::table)
                    ->select(ProductController::amount)
                    ->where(ProductController::id, '=', $arr_value[self::product_id])
                    ->get();

                $sl = $sl[0]->amount;
                if ($arr_value[self::amount] > $sl) {
                    return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
                }
                // $ngay_lap = DB::table(HoaDonController::table)->where(HoaDonController::table . '.' . HoaDonController::id, '=', $arr_value[self::ma_hoa_don])
                //     ->where(HoaDonController::table . '.' . HoaDonController::isActive, '=', true)
                //     ->select(HoaDonController::ngay_lap)->get();
                // $ngay_lap = $ngay_lap[0]->ngay_lap;
                // $ma_ngay_km = DB::table(NgayKhuyenMaiController::table)
                //     ->select(NgayKhuyenMaiController::id)
                //     ->where(NgayKhuyenMaiController::table . '.' . NgayKhuyenMaiController::ngay_gio, '=', $ngay_lap)
                //     ->where(NgayKhuyenMaiController::table . '.' . NgayKhuyenMaiController::isActive, '=', true)
                //     ->get();
                // $muc_km = 0;
                // if (count($ma_ngay_km) > 0) {
                //     $ma_ngay_km = $ma_ngay_km->ma_ngay_khuyen_mai;
                //     $muc_km = DB::table(KhuyenMaiSanPhamController::table)
                //         ->where(KhuyenMaiSanPhamController::table . '.' . KhuyenMaiSanPhamController::ma_san_pham, '=', $arr_value[self::ma_san_pham])
                //         ->where(KhuyenMaiSanPhamController::table . '.' . KhuyenMaiSanPhamController::ma_ngay_khuyen_mai, '=', $ma_ngay_km)
                //         ->where(KhuyenMaiSanPhamController::table . '.' . KhuyenMaiSanPhamController::isActive, '=', true)
                //         ->select(KhuyenMaiSanPhamController::muc_khuyen_mai)->get();
                // }
                // $gia_ban_sp = DB::table(SanPhamController::table)->where(SanPhamController::table . '.' . SanPhamController::id, '=', $arr_value[self::ma_san_pham])
                //     ->where(SanPhamController::isActive, '=', true)
                //     ->select(SanPhamController::gia_ban)->get();
                // $gia_ban_sp = $gia_ban_sp[0]->gia_ban;
                // if ($muc_km > 0) {
                //     $arr_value[self::gia_ban] = $gia_ban_sp * (1 - $muc_km / 100);
                // } else {
                //     $arr_value[self::gia_ban] = $gia_ban_sp;
                // }
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
