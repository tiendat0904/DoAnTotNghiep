<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CommnentController extends Controller
{
    private $base;
    const table = 'comment';
    const id = 'comment_id';
    const product_id = 'product_id';
    const customer_id = 'customer_id';
    const comment_content = 'comment_content';
    const create_at = 'create_at';

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
        $validator = Validator::make($request->all(), [
            self::comment_content => 'required',
            self::customer_id => 'required',
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->all()], 400);
        }

        $obj = [];
        $obj[self::customer_id] = $user->account_id;
        $obj[self::comment_content] = $request->comment_content;
        if (DB::table(self::table)->insert($obj)) {
            return response()->json(['success' => 'Thêm mới thành công'], 201);
        } else {
            return response()->json(['error' => 'Thêm mới thất bại'], 400);
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
        $user = auth()->user();
        $ma_tk = $user->account_id;
        $ma_kh = DB::table(self::table)->where(self::id, '=', $id)->get(self::customer_id)->first();
        if ($ma_kh == $ma_tk) {
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
        $loai_tk = $user->account_type_id;
        $ma_tk = $user->account_id;
        try {
            if ($listId = $request->get(BaseController::listId)) {
                if (count($listId) > 0) {
                    foreach ($listId as $id) {
                        $ma_kh = DB::table(self::table)->where(self::id, '=', $id)->get(self::customer_id);
                        if ($loai_tk != AccountController::NV && $loai_tk != AccountController::QT && $ma_kh != $ma_tk) {
                            return response()->json(['error' => 'Xóa thất bại. Bạn không được phép xóa nhận xét của người khác'], 403);
                        }
                    }
                    DB::table(self::table)->whereIn(self::id, $listId)->delete();
                    return response()->json(['success' => 'Xóa thành công'], 200);
                } else {
                    return response()->json(['error' => 'Xóa thất bại. Không có dữ liệu'], 400);
                }
            } else {
                $id = $request->get(BaseController::key_id);
                $ma_kh = DB::table(self::table)->where(self::id, '=', $id)->get(self::customer_id)->first();
                if ($loai_tk == AccountController::NV || $loai_tk == AccountController::QT || $ma_kh == $ma_tk) {
                    if ($obj = DB::table(self::table)->where(self::id, '=', $id)->delete()) {
                        return response()->json(['success' => 'Xóa thành công'], 200);
                    } else {
                        return response()->json(['error' => 'Xóa thất bại'], 400);
                    }
                } else {
                    return response()->json(['error' => 'Tài khoản không đủ quyền để thực hiện thao tác này'], 403);
                }
            }
        } catch (\Throwable $e) {
            report($e);
            return response()->json(['error' => $e], 500);
        }
    }
}
