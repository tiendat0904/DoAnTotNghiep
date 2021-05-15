<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ProductImageController extends Controller
{
    private $base;
    const table = 'product_image';
    const id = 'product_image_id';
    const product_id = 'product_id';
    const image = 'image';

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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $arr_value = $request->all();
            if (count($arr_value) > 0) {
                $validator = Validator::make($arr_value, [
                    self::product_id => 'required',
                    self::image => 'required',
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
                $objs = [];
                $images = $arr_value[self::image];
                if (count($images) > 0) {
                    foreach ($images as $image) {
                        $objs[self::product_id] = $request->product_id;
                        $objs[self::image] = $image;
                        DB::table(self::table)->insert($objs);
                    }
                    return response()->json(['success' => "Thêm mới thành công"], 201);
                } else {
                    return response()->json(['error' => "Thêm mới thất bại. Không có dữ liệu"], 400);
                }
            } else {
                return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            }
            // try {
            //     if ($listObj = $request->get(BaseController::listObj)) {
            //         $count = count($listObj);
            //         if ($count > 0) {
            //             foreach ($listObj as $obj) {
            //                 $validator = Validator::make($obj, [
            //                     self::product_id => 'required',
            //                     self::image => 'required',
            //                 ]);
            //                 if ($validator->fails()) {
            //                     return response()->json(['error' => $validator->errors()->all()], 400);
            //                 }
            //             }
            //         } else {
            //             return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            //         }
            //     } else {
            //         $arr_value = $request->all();
            //         if (count($arr_value) > 0) {
            //             $validator = Validator::make($arr_value, [
            //                 self::product_id => 'required',
            //                 self::image => 'required',
            //             ]);
            //             if ($validator->fails()) {
            //                 return response()->json(['error' => $validator->errors()->all()], 400);
            //             }
            //             $objs = [];
            //             $images=$arr_value[self::image];
            //             foreach($images as $image){
            //                 $objs[self::product_id] = $request->product_id;
            //                 $objs[self::image] = $image;
            //             }
            //             foreach($objs as $obj){
            //                 DB::table($this->table)->insert($obj);
            //             }
            //         } else {
            //             return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            //         }
            //     }
            // } catch (\Throwable $e) {
            //     return response()->json(['error' => $e], 500);
            // }

            // $this->base->store($request);
            // return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
        //     $arr_value = $request->all();
        //     if (count($arr_value) > 0) {
        //         $validator = Validator::make($arr_value, [
        //             self::product_id => 'required',
        //             self::image => 'required',
        //         ]);
        //         if ($validator->fails()) {
        //             return response()->json(['error' => $validator->errors()->all()], 400);
        //         }
        //     } else {
        //         return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
        //     }
        //     $this->base->store($request);
        //     return response()->json($this->base->getMessage(), $this->base->getStatus());
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
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
        $obj = DB::table(self::table)
            ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name)
            ->where(self::table . '.' . self::id, '=', $id)
            ->get();
        if ($obj) {
            return response()->json(['data' => $obj], 200);
        } else {
            return response()->json(['error' => 'Không tìm thấy'], 200);
        }
    }


    public function showbyproduct($id)
    {
        //
        $obj = DB::table(self::table)
            ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name)
            ->where(ProductController::table . '.' . ProductController::id, '=', $id)
            ->get();
        if ($obj) {
            return response()->json(['data' => $obj], 200);
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
    public function update(Request $request)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $arr_value = $request->all();
            $validator = Validator::make($request->all(), [
                self::product_id => 'required'
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }

            $objs = [];
                $images = $arr_value[self::image];
                if (count($images) > 0) {
                    foreach ($images as $image) {
                        $objs[self::product_id] = $request->product_id;
                        $objs[self::image] = $image;
                        DB::table(self::table)->insert($objs);
                    }
                }

            
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
