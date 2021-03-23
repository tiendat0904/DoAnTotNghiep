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
    const price = 'price';
    const amount = 'amount';

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
        $objs = DB::table(self::table)
        ->join(ProductTypeController::table, self::table . '.' . self::product_type_id, '=', ProductTypeController::table . '.' . ProductTypeController::id)
        ->join(TradeMarkController::table, self::table . '.' . self::trademark_id, '=', TradeMarkController::table . '.' . TradeMarkController::id)
        ->select(self::id, self::product_name, TradeMarkController::table . '.' . TradeMarkController::id, TradeMarkController::table . '.' . TradeMarkController::trademark_name, ProductTypeController::table . '.' . ProductTypeController::id, ProductTypeController::table . '.' . ProductTypeController::product_type_name, self::price, self::amount)
        ->get();
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
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $validator = Validator::make($request->all(), [
                self::product_name => 'required',
                self::trademark_id => 'required',
                self::product_type_id => 'required',
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
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
        $objs = DB::table(self::table)
        ->join(ProductTypeController::table, self::table . '.' . self::product_type_id, '=', ProductTypeController::table . '.' . ProductTypeController::id)
        ->join(TradeMarkController::table, self::table . '.' . self::trademark_id, '=', TradeMarkController::table . '.' . TradeMarkController::id)
        ->select(self::id, self::product_name, TradeMarkController::table . '.' . TradeMarkController::id, TradeMarkController::table . '.' . TradeMarkController::trademark_name, ProductTypeController::table . '.' . ProductTypeController::id, ProductTypeController::table . '.' . ProductTypeController::product_type_name, self::price, self::amount)
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
