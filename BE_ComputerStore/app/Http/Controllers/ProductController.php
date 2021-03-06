<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ProductController extends Controller
{
    private $base;
    const table = 'product';
    const id = 'product_id';
    const product_name = 'product_name';
    const trademark_id = 'trademark_id';
    const product_type_id = 'product_type_id';
    const product_type_name = 'product_type_name';
    const price = 'price';
    const amount = 'amount';
    const warranty = 'warranty';
    // const image = 'image';
    const description = 'description';
    const created_at = 'created_at';
    const createdBy = 'createdBy';
    const updatedBy = 'updatedBy';
    const updatedDate = 'updatedDate';
    const image = "image";

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
        $date = date('Y-m-d');
        $objs = null;
        $code = null;
        try {
            $objs = DB::select('call listProduct(?)', array($date));
            if (count($objs) == 0) {
                $objs = DB::table('products')->get();
            }
            foreach ($objs as $obj) {
                $obj_images = DB::table(ProductImageController::table)
                    ->join(self::table, self::table . '.' . self::id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
                    ->select(ProductImageController::table . '.' . ProductImageController::image)
                    ->where(self::table . '.' . self::id, '=', $obj->product_id)
                    ->get();
                foreach ($obj_images as $obj_image) {
                    $obj->image[] =  $obj_image->image;
                }
            }
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } catch (\Throwable $e) {
            $objs = DB::table('products')->get();
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
            $arr_value = $request->all();
            $validator = Validator::make($request->all(), [
                self::product_name => 'required',
                self::trademark_id => 'required',
                self::product_type_id => 'required',
                self::warranty => 'required',
                self::description => ' required',
                "image" => 'required',
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            $arr_value1 = [];
            $data = DB::table(self::table)->where(self::product_name, '=', $request->product_name)->get();
            if (count($data) > 0) {
                return response()->json(['error' => '???? t???n t???i t??n s???n ph???m n??y'], 400);
            }
            $arr_value1[self::product_name] = $request->product_name;
            $arr_value1[self::trademark_id] = $request->trademark_id;
            $arr_value1[self::product_type_id] = $request->product_type_id;
            $arr_value1[self::description] = $request->description;
            $arr_value1[self::warranty] = $request->warranty;
            $arr_value1[self::created_at] = date('Y-m-d h:i:s');
            $arr_value1[self::createdBy] = $user->account_id;
            DB::table(self::table)->insert($arr_value1);
            $product_id = DB::table(self::table)->latest('product_id')->select(self::table . '.' . self::id)->first();
            $objs = [];
            $images = $arr_value['image'];
            if (count($images) > 0) {
                foreach ($images as $image) {
                    $objs[self::id] = $product_id->product_id;
                    $objs['image'] = $image;

                    DB::table(ProductImageController::table)->insert($objs);
                }
            }
            return response()->json(['success' => "Th??m m???i th??nh c??ng", "data" =>  $arr_value1], 201);
        } else {
            return response()->json(['error' => 'T??i kho???n kh??ng ????? quy???n truy c???p'], 403);
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
        $objs = null;
        date_default_timezone_set(BaseController::timezone);
        $date = date('Y-m-d');
        $objs = DB::select('call itemProduct(?,?)', array($date, $id));
        $obj_images = DB::table(ProductImageController::table)
            ->join(self::table, self::table . '.' . self::id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
            ->select(ProductImageController::table . '.' . ProductImageController::image)
            ->where(self::table . '.' . self::id, '=', $objs[0]->product_id)
            ->get();
        foreach ($obj_images as $obj_image) {
            $objs[0]->image[] =  $obj_image->image;
        }
        if ($objs) {
            return response()->json(['data' => $objs[0]], 200);
        } else {
            return response()->json(['error' => 'Kh??ng t??m th???y'], 200);
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
            $arr_value = [];
            if ($request->product_name) {
                $arr_value[self::product_name] = $request->product_name;
            }
            if ($request->trademark_id) {
                $arr_value[self::trademark_id] = $request->trademark_id;
            }
            if ($request->product_type_id) {
                $arr_value[self::product_type_id] = $request->product_type_id;
            }
            if ($request->description) {
                $arr_value[self::description] = $request->description;
            }
            if ($request->warranty) {
                $arr_value[self::warranty] = $request->warranty;
            }
            $arr_value[self::updatedDate] = date('Y-m-d h:i:s');
            $arr_value[self::updatedBy] = $user->account_id;
            if (count($arr_value) == 1) {
                return response()->json(['error' => 'Ch???nh s???a th???t b???i. Thi???u th??ng tin'], 400);
            }
            $objs = [];
            if ($request->image) {
                $images = $request->image;
                if (count($images) > 0) {
                    foreach ($images as $image) {
                        $objs[self::id] = $request->product_id;
                        $objs[self::image] = $image;
                        DB::table(ProductImageController::table)->insert($objs);
                    }
                }
            }
            DB::table(self::table)->where(self::id, $id)->update($arr_value);
            return response()->json(['success' => 'Ch???nh s???a th??nh c??ng'], 201);
            // return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'T??i kho???n kh??ng ????? quy???n truy c???p'], 403);
        }
    }

    public function updateview(Request $request, $id)
    {
        //
        $obj = [];
        $obj = $request->all();
        if (count($obj) == 1) {
            return response()->json(['error' => 'Ch???nh s???a th???t b???i. Thi???u th??ng tin'], 400);
        }
        DB::table(self::table)->where(self::id, $id)->update($obj);
        return response()->json(['success' => 'Ch???nh s???a th??nh c??ng'], 201);
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
            if ($request->product_id) {
                $coupon = DB::table(CouponDetailController::table)
                    ->where(CouponDetailController::product_id, '=', $request->product_id)
                    ->get();
                if (count($coupon) > 0) {
                    return response()->json(['error' => 'S???n ph???m ???? c?? trong phi???u nh???p, vui l??ng ki???m tra l???i !!!'], 400);
                }
                $bill = DB::table(BillDetailController::table)
                    ->where(BillDetailController::product_id, '=', $request->product_id)
                    ->get();
                if (count($coupon) > 0) {
                    return response()->json(['error' => 'S???n ph???m ???? c?? trong h??a ????n, vui l??ng ki???m tra l???i !!!'], 400);
                }
            }
            $this->base->destroy($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'T??i kho???n kh??ng ????? quy???n truy c???p'], 403);
        }
    }
}
