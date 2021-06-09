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
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $objs = null;
            $code = null;
            $objs = DB::table(self::table)
                ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
                ->leftjoin(ProductImageController::table, self::table . '.' . self::product_id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
                ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, ProductImageController::table . '.' . ProductImageController::image, ProductController::table . '.' . ProductController::warranty)
                ->groupBy(self::bill_id, self::product_id)
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 400);
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
        // date_default_timezone_set(BaseController::timezone);
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            // DB::table(BillController::table)
            //     ->insert([BillController::order_status_id => 1,
            //     BillController::customer_id => $ac_id,
            //     BillController::created_at => date('Y-m-d')]);
            // $bill_id = DB::table(BillController::table)->select(self::id)->latest();
            try {
                if ($listObj = $request->get(BaseController::listObj)) {
                    $count = count($listObj);
                    if ($count > 0) {
                        foreach ($listObj as $obj) {
                            $validator = Validator::make($obj, [
                                self::bill_id => "required",
                                self::product_id => 'required',
                                self::price => 'required',
                                self::amount => 'required',
                            ]);

                            if ($validator->fails()) {
                                return response()->json(['error' => $validator->errors()->all()], 400);
                            }

                            $data = DB::table(self::table)
                                ->select(self::table . '.*')
                                ->where(self::product_id, '=', $request->product_id)
                                ->where(self::bill_id, '=', $request->bill_id)
                                ->get();
                            if (count($data) > 0) {
                                return response()->json(['error' => 'Đã có sản phẩm trong giỏ hàng'], 403);
                            }
                            $this->base->store($request);
                            return response()->json($this->base->getMessage(), $this->base->getStatus());

                            // if (self::amount < 1) {
                            //     return response()->json(['error' => 'Số lượng phải lớn hơn 0'], 400);
                            // }

                            // $data = DB::table(self::table)
                            //     ->select(self::table . '.*')
                            //     ->where(self::product_id, '=', self::product_id)
                            //     ->where(self::bill_id, '=', self::bill_id)
                            //     ->get();
                            // if (count($data) > 0) {
                            //     return response()->json(['error' => 'Thêm mới thất bại. Có 1 row đã tồn tại mã hóa đơn và mã sản phẩm'], 400);
                            // }
                            // $sl = DB::table(ProductController::table)
                            //     ->select(ProductController::amount)
                            //     ->where(ProductController::id, '=', self::product_id)
                            //     ->get();

                            // $sl = $sl[0]->amount;
                            // if (self::amount > $sl) {
                            //     return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
                            // }
                        }
                    } else {
                        return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
                    }
                } else {
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
                            return response()->json(['error' => 'Sản phẩm đã có trong giỏ hàng'], 400);
                        } else {
                            $sl = DB::table(ProductController::table)
                                ->select(ProductController::amount)
                                ->where(ProductController::id, '=', $arr_value[self::product_id])
                                ->get();
                            $sl = $sl[0]->amount;
                            if ($arr_value[self::amount] > $sl) {
                                return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
                            }
                            $this->base->store($request);
                            return response()->json($this->base->getMessage(), $this->base->getStatus());
                        }
                    } else {
                        return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
                    }
                }
            } catch (\Throwable $e) {
                return response()->json(['error' => $e], 500);
            }
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
        // $arr_value = $request->all();
        // if (count($arr_value) > 0) {
        //     $validator = Validator::make($arr_value, [
        //         self::bill_id => 'required',
        //         self::product_id => 'required',
        //         self::price => 'required',
        //         self::amount => 'required',
        //     ]);
        //     if ($validator->fails()) {
        //         return response()->json(['error' => $validator->errors()->all()], 400);
        //     }
        //     if ($arr_value[self::amount] < 1) {
        //         return response()->json(['error' => 'Số lượng phải lớn hơn 0'], 400);
        //     }

        //     $data = DB::table(self::table)
        //         ->select(self::table . '.*')
        //         ->where(self::product_id, '=', $arr_value[self::product_id])
        //         ->where(self::bill_id, '=', $arr_value[self::bill_id])
        //         ->get();
        //     if (count($data) > 0) {
        //         return response()->json(['error' => 'Thêm mới thất bại. Có 1 row đã tồn tại mã hóa đơn và mã sản phẩm'], 400);
        //     }
        //     $sl = DB::table(ProductController::table)
        //         ->select(ProductController::amount)
        //         ->where(ProductController::id, '=', $arr_value[self::product_id])
        //         ->get();

        //     $sl = $sl[0]->amount;
        //     if ($arr_value[self::amount] > $sl) {
        //         return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
        //     }
        //     DB::table(self::table)->insert($arr_value);
        //     return response()->json(['success' => 'Thêm mới thành công'], 201);
        // } else {
        //     return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
        // }
    }

    public function storenotaccount(Request $request)
    {
        //
        // date_default_timezone_set(BaseController::timezone);
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
        // DB::table(BillController::table)
        //     ->insert([BillController::order_status_id => 1,
        //     BillController::customer_id => $ac_id,
        //     BillController::created_at => date('Y-m-d')]);
        // $bill_id = DB::table(BillController::table)->select(self::id)->latest();
        try {
            if ($listObj = $request->get(BaseController::listObj)) {
                $count = count($listObj);
                if ($count > 0) {
                    foreach ($listObj as $obj) {
                        $validator = Validator::make($obj, [
                            self::bill_id => "required",
                            self::product_id => 'required',
                            self::price => 'required',
                            self::amount => 'required'
                        ]);

                        if ($validator->fails()) {
                            return response()->json(['error' => $validator->errors()->all()], 400);
                        }

                        $data = DB::table(self::table)
                            ->select(self::table . '.*')
                            ->where(self::product_id, '=', self::product_id)
                            ->where(self::bill_id, '=', self::bill_id)
                            ->get();
                        if (count($data) > 0) {
                            return response()->json(['error' => 'Sản phẩm đã có trong giỏ hàng'], 400);
                        }

                        $this->base->store($request);
                        return response()->json($this->base->getMessage(), $this->base->getStatus());

                        // if (self::amount < 1) {
                        //     return response()->json(['error' => 'Số lượng phải lớn hơn 0'], 400);
                        // }

                        // $data = DB::table(self::table)
                        //     ->select(self::table . '.*')
                        //     ->where(self::product_id, '=', self::product_id)
                        //     ->where(self::bill_id, '=', self::bill_id)
                        //     ->get();
                        // if (count($data) > 0) {
                        //     return response()->json(['error' => 'Thêm mới thất bại. Có 1 row đã tồn tại mã hóa đơn và mã sản phẩm'], 400);
                        // }
                        // $sl = DB::table(ProductController::table)
                        //     ->select(ProductController::amount)
                        //     ->where(ProductController::id, '=', self::product_id)
                        //     ->get();

                        // $sl = $sl[0]->amount;
                        // if (self::amount > $sl) {
                        //     return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
                        // }
                    }
                } else {
                    return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
                }
            } else {
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
                        // return response()->json(['error' => 'Thêm mới thất bại. Có 1 row đã tồn tại mã hóa đơn và mã sản phẩm'], 400);
                    } else {
                        $sl = DB::table(ProductController::table)
                            ->select(ProductController::amount)
                            ->where(ProductController::id, '=', $arr_value[self::product_id])
                            ->get();

                        $sl = $sl[0]->amount;
                        if ($arr_value[self::amount] > $sl) {
                            return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
                        }

                        $this->base->store($request);
                        return response()->json($this->base->getMessage(), $this->base->getStatus());
                    }
                } else {
                    return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
                }
            }
        } catch (\Throwable $e) {
            return response()->json(['error' => $e], 500);
        }
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        // }


        // $arr_value = $request->all();
        // if (count($arr_value) > 0) {
        //     $validator = Validator::make($arr_value, [
        //         self::bill_id => 'required',
        //         self::product_id => 'required',
        //         self::price => 'required',
        //         self::amount => 'required',
        //     ]);
        //     if ($validator->fails()) {
        //         return response()->json(['error' => $validator->errors()->all()], 400);
        //     }
        //     if ($arr_value[self::amount] < 1) {
        //         return response()->json(['error' => 'Số lượng phải lớn hơn 0'], 400);
        //     }

        //     $data = DB::table(self::table)
        //         ->select(self::table . '.*')
        //         ->where(self::product_id, '=', $arr_value[self::product_id])
        //         ->where(self::bill_id, '=', $arr_value[self::bill_id])
        //         ->get();
        //     if (count($data) > 0) {
        //         return response()->json(['error' => 'Thêm mới thất bại. Có 1 row đã tồn tại mã hóa đơn và mã sản phẩm'], 400);
        //     }
        //     $sl = DB::table(ProductController::table)
        //         ->select(ProductController::amount)
        //         ->where(ProductController::id, '=', $arr_value[self::product_id])
        //         ->get();

        //     $sl = $sl[0]->amount;
        //     if ($arr_value[self::amount] > $sl) {
        //         return response()->json(['error' => 'Thêm mới thất bại. Số lượng sản phẩm không đủ'], 400);
        //     }



        //     DB::table(self::table)->insert($arr_value);
        //     return response()->json(['success' => 'Thêm mới thành công'], 201);
        // } else {
        //     return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
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
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
        $objs = DB::table(self::table)
            ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
            ->join(BillController::table, self::table . '.' . self::bill_id, '=', BillController::table . '.' . BillController::id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, ProductController::table . '.' . ProductController::warranty, BillController::table . '.' . BillController::created_at, BillController::table . '.' . BillController::updatedDate, BillController::table . '.' . BillController::order_status_id)
            ->where(self::table . '.' . self::id, '=', $id)->first();
        if ($objs) {
            return response()->json(['data' => $objs], 200);
        } else {
            return response()->json(['message' => "Không tìm thấy"], 200);
        }
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        // }
    }

    public function showbybill($id)
    {
        //
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
        $objs = DB::table(self::table)
            ->join(ProductImageController::table, self::table . '.' . self::product_id, '=', ProductImageController::table . '.' . ProductImageController::product_id)
            ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
            ->join(BillController::table, self::table . '.' . self::bill_id, '=', BillController::table . '.' . BillController::id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, ProductController::table . '.' . ProductController::warranty, ProductImageController::table . '.' . ProductImageController::image, BillController::table . '.' . BillController::created_at, BillController::table . '.' . BillController::order_status_id)
            ->where(self::table . '.' . self::bill_id, '=', $id)->groupBy(self::bill_id, self::product_id)->get();
        if ($objs) {
            return response()->json(['data' => $objs], 200);
        } else {
            return response()->json(['message' => "Không tìm thấy"], 200);
        }
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        // }
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
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $this->base->update($request, $id);
            $update_bills = [];
            $update_total_money = null;
            $update_bills = DB::table(self::table)->where(self::bill_id, '=', $request->bill_id)->get();
            foreach ($update_bills as $update_bill) {
                $update_total_money += (float)$update_bill->price * (float)$update_bill->amount;
            }
            DB::table(BillController::table)->where(BillController::id, '=', $request->bill_id)->update([BillController::total_money => $update_total_money, BillController::into_money => $update_total_money]);
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
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT || $ac_type == AccountController::KH) {
            $this->base->destroy($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }
}
