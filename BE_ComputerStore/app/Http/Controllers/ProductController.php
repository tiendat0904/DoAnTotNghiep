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
                return response()->json(['error' => 'Đã tồn tại tên sản phẩm này'], 400);
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
            return response()->json(['success' => "Thêm mới thành công", "data" =>  $arr_value1], 201);
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
            return response()->json(['error' => 'Không tìm thấy'], 200);
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
            $obj = [];
            $obj = $request->all();
            $obj[self::updatedDate] = date('Y-m-d h:i:s');
            $obj[self::updatedBy] = $user->account_id;
            if (count($obj) == 1) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Thiếu thông tin'], 400);
            }
            DB::table(self::table)->where(self::id, $id)->update($obj);
            return response()->json(['success' => 'Chỉnh sửa thành công'], 201);
            // return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    public function updateview(Request $request, $id)
    {
        //
            $obj = [];
            $obj = $request->all();
            if (count($obj) == 1) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Thiếu thông tin'], 400);
            }
            DB::table(self::table)->where(self::id, $id)->update($obj);
            return response()->json(['success' => 'Chỉnh sửa thành công'], 201);
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
