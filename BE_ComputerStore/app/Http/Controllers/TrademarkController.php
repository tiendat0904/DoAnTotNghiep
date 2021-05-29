<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;


class TrademarkController extends Controller
{
    private $base;
    const table = 'trademark';
    const id = 'trademark_id';
    const trademark_name = 'trademark_name';
    const image = 'image';
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
        $this->base->index();
        return response()->json($this->base->getMessage(), $this->base->getStatus());
    }

    public function getTrademark()
    {
        //
        $objs = DB::table(self::table)
            ->leftJoin(ProductController::table, ProductController::table . '.' . ProductController::trademark_id, '=', self::table . '.' . self::id)
            ->select(array(self::table . '.*', DB::raw('COUNT(product.product_id) as totalProduct')))
            ->groupBy(self::table . '.' . self::id)
            ->orderBy('totalProduct','desc')
            ->get();
        return response()->json(['data' => $objs], 200);
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
        date_default_timezone_set(BaseController::timezone);
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $arr_value = $request->all();
            if (count($arr_value) > 0) {
                $validator = Validator::make($arr_value, [
                    self::trademark_name => 'required',
                    self::image => 'required',
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
                $data = DB::table(self::table)
                    ->select(self::table . '.*')
                    ->where(self::trademark_name, '=', $request->trademark_name)
                    ->get();
                if (count($data) > 0) {
                    return response()->json(['error' => 'Tên nhãn hiệu đã tồn tại vui lòng kiểm tra lại!!!'], 400);
                }
            } else {
                return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            }
            $arr_value = [];
            $arr_value = $request->all();
            $arr_value[self::created_at] = date('Y-m-d h:i:s');
            $arr_value[self::createdBy] = $user->account_id;
            DB::table(self::table)->insert($arr_value);
            return response()->json(['success' => "Thêm mới thành công", "data" =>  $arr_value], 201);
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
        $this->base->show($id);
        return response()->json($this->base->getMessage(), $this->base->getStatus());
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
        date_default_timezone_set(BaseController::timezone);
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
