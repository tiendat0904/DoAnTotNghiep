<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CartController extends Controller
{
    private $base;
    const table = 'cart';
    const id = 'cart_id';
    const customer_id = 'customer_id';
    const product_id = 'product_id';
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
        $objs = null;
            $code = null;
            $objs = DB::table(self::table)
            ->join(ProductController::table, ProductController::table . '.' . ProductController::id, '=', self::table . '.' . self::product_id)
            ->join(AccountController::table, self::table . '.' . self::customer_id, '=', AccountController::table . '.' . AccountController::id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, AccountController::table . '.' . AccountController::full_name . ' as customer_name')
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
        try {
            if ($listObj = $request->get(BaseController::listObj)) {
                $count = count($listObj);
                if ($count > 0) {
                    foreach ($listObj as $obj) {
                        $validator = Validator::make($obj, [
                            self::product_id => 'required',
                            self::customer_id => 'required',
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
                        self::customer_id => 'required',
                    ]);
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
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
