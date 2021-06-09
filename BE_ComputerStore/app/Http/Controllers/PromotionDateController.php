<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PromotionDateController extends Controller
{

    private $base;
    const table = 'promotion_date';
    const id = 'promotion_date_id';
    const date = 'date';

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
            $this->base->index();
            return response()->json($this->base->getMessage(), $this->base->getStatus());
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
        // return response()->json(['data' => $request->listProduct], 201);
        date_default_timezone_set(BaseController::timezone);
        $date = date('Y-m-d');
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $arr_value = $request->all();
            if (count($arr_value) > 0) {
                $validator = Validator::make($arr_value, [
                    self::date => 'required',
                    'promotion_level' => 'required',
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
                $time = strtotime($arr_value[self::date]);
                $ngay = date('Y-m-d', $time);
                if (date('Y-m-d', $time) < $date) {
                    return response()->json(['error' => 'Ngày không hợp lệ. Ngày nhập phải lớn hơn ngày hiện tại'], 400);
                }
                $ngay_km = DB::table(self::table)->whereDate(self::date, '=', date('Y-m-d', $time))->get();
                if (count($ngay_km) > 0) {
                    return response()->json(['error' => 'Đã tồn tại ngày khuyến mãi này, vui lòng kiểm tra lại !!!'], 400);
                }
                if ((int)$arr_value['promotion_level'] < 0 || (int)$arr_value['promotion_level'] > 100) {
                    return response()->json(['error' => 'Mức khuyến mãi không hợp lệ'], 400);
                }
            } else {
                return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            }
            $products = [];
            $products = $request->listProduct;
            DB::table(self::table)->insert([self::date => $arr_value[self::date]]);
            $ma_ngay_km = DB::table(self::table)->select(self::id)
                ->whereDate(self::date, '=', $ngay)->first();
            foreach ($products as $product) {
                DB::table(ProductPromotionController::table)
                    ->insert([
                        ProductPromotionController::product_id => $product['product_id'],
                        ProductPromotionController::promotion_date_id => $ma_ngay_km->promotion_date_id,
                        ProductPromotionController::promotion_level => $arr_value['promotion_level']
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
                ->join(ProductPromotionController::table, self::table . '.' . self::id, '=', ProductPromotionController::table . '.' . ProductPromotionController::promotion_date_id)
                ->select(self::table . '.*', ProductPromotionController::table . '.' . ProductPromotionController::promotion_level, ProductPromotionController::table . '.' . ProductPromotionController::product_id)
                ->where(self::table . '.' . self::id, '=', $id)
                ->get();
            foreach ($objs as $obj) {
                $obj_products = DB::table(ProductController::table)
                    ->join(ProductPromotionController::table, ProductPromotionController::table . '.' . ProductPromotionController::product_id, '=', ProductController::table . '.' . ProductController::id)
                    ->join(ProductTypeController::table, ProductTypeController::table . '.' . ProductTypeController::id, '=', ProductController::table . '.' . ProductController::product_type_id)
                    ->join(TrademarkController::table, TrademarkController::table . '.' . TrademarkController::id, '=', ProductController::table . '.' . ProductController::trademark_id)
                    ->select(ProductController::table . '.*', ProductTypeController::table . '.' . ProductTypeController::product_type_name, TrademarkController::table . '.' . TrademarkController::trademark_name)
                    ->where(ProductController::table . '.' . ProductController::id, '=', $obj->product_id)
                    ->get();
                foreach ($obj_products as $obj_product) {
                    $obj_images = DB::table(ProductImageController::table)
                        ->join(ProductController::table, ProductController::table . '.' . ProductController::id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
                        ->select(ProductImageController::table . '.' . ProductImageController::image)
                        ->where(ProductController::table . '.' . ProductController::id, '=', $obj->product_id)
                        ->get();
                    foreach ($obj_images as $obj_image) {
                        $obj_product->image[] =  $obj_image->image;
                    }
                    $obj->listProduct[] =  $obj_product;
                }
            }
            $code = 200;
            return response()->json(['data' => $objs], $code);
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
