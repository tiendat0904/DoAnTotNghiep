<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class BuildPCController extends Controller
{
    private $base;
    const table = 'build_pc';
    const id = 'build_pc_id';
    const customer_id = 'customer_id';
    const product_id = 'product_id';
    const quantity = 'quantity';

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
        if ($ac_type == AccountController::KH) {
            $objs = DB::table(self::table)
                ->Join(ProductImageController::table, self::table . '.' . self::product_id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
                ->Join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
                ->Join(ProductTypeController::table, ProductTypeController::table . '.' . ProductTypeController::id, '=', ProductController::table . '.' . ProductController::product_type_id)
                ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, ProductImageController::table . '.' . ProductImageController::image, ProductController::table . '.' . ProductController::warranty, ProductTypeController::table . '.' . ProductTypeController::product_type_name, ProductController::table . '.' . ProductController::product_type_id)
                ->get();
            return response()->json(['data' => $objs], 200);
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
        if ($ac_type == AccountController::KH) {
            $arr_value = $request->all();
            if (count($arr_value) > 0) {
                $validator = Validator::make($arr_value, [
                    self::customer_id => 'required',
                    self::product_id => 'required',
                    self::quantity => 'required',
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
            } else {
                return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            }
            $data = DB::table(self::table)
                ->select(self::table . '.*')
                ->where(self::product_id, '=', $arr_value[self::product_id])
                ->where(self::customer_id, '=', $arr_value[self::customer_id])
                ->get();
            if (count($data) > 0) {
            } else {
                $this->base->store($request);
                return response()->json($this->base->getMessage(), $this->base->getStatus());
            }
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
        if ($ac_type == AccountController::KH) {
            $objs = DB::table(self::table)
                ->Join(ProductImageController::table, self::table . '.' . self::product_id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
                ->Join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
                ->Join(ProductTypeController::table, ProductTypeController::table . '.' . ProductTypeController::id, '=', ProductController::table . '.' . ProductController::product_type_id)
                ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, ProductImageController::table . '.' . ProductImageController::image, ProductController::table . '.' . ProductController::warranty, ProductTypeController::table . '.' . ProductTypeController::product_type_name, ProductController::table . '.' . ProductController::product_type_id)
                ->where(self::table . '.' . self::customer_id, '=', $id)->get();
            if ($objs) {
                return response()->json(['data' => $objs], 200);
            } else {
                return response()->json(['message' => "Không tìm thấy"], 200);
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
        if ($ac_type == AccountController::KH) {
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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::KH) {
            $this->base->destroy($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }
}
