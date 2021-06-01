<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ProductPromotionController extends Controller
{

    private $base;
    const table = 'product_promotion';
    const id = 'product_promotion_id';
    const product_id = 'product_id';
    const promotion_date_id = 'promotion_date_id';
    const promotion_level = 'promotion_level';

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
        date_default_timezone_set(BaseController::timezone);
        $date = date('d-m-Y');
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $objs = DB::table(self::table)
                ->leftJoin(ProductController::table, ProductController::table . '.' . ProductController::id, '=', self::table . '.' . self::product_id)
                ->join(PromotionDateController::table, PromotionDateController::table . '.' . PromotionDateController::id, '=', self::table . '.' . self::promotion_date_id)
                ->select(self::table . '.' . self::id, self::table . '.' . self::product_id, ProductController::table . '.' . ProductController::product_name, self::table . '.' . self::promotion_date_id, PromotionDateController::table . '.' . PromotionDateController::date, self::promotion_level)        
                ->get();
            return response()->json(['data' => $objs], 200);
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
            try {
                if ($listObj = $request->get(BaseController::listObj)) {
                    $count = count($listObj);
                    if ($count > 0) {
                        foreach ($listObj as $obj) {
                            $validator = Validator::make($obj, [
                                self::product_id => 'required',
                                self::promotion_date_id => 'required',
                                self::promotion_level => 'required',
                            ]);
                            if ($validator->fails()) {
                                return response()->json(['error' => $validator->errors()->all()], 400);
                            }
                        }
                    } else {
                        return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
                    }
                } else {
                    $arr_value = $request->all();
                    if (count($arr_value) > 0) {
                        $validator = Validator::make($arr_value, [
                            self::product_id => 'required',
                            self::promotion_date_id => 'required',
                            self::promotion_level => 'required',
                        ]);
                        $productPromotion = DB::table(self::table)
                        ->where(self::product_id ,'=', $request->product_id)
                        ->where(self::promotion_date_id , '', $request->promotion_date_id)
                        ->get();
                        if(count($productPromotion)>0){
                            return response()->json(['error' => 'Sản phẩm đã có khuyến mãi trong ngày hôm đấy, vui lòng kiểm tra lại !!!'], 400);
                        }
                        if ($validator->fails()) {
                            return response()->json(['error' => $validator->errors()->all()], 400);
                        }
                    } else {
                        return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
                    }
                }
            } catch (\Throwable $e) {
                return response()->json(['error' => $e], 500);
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
