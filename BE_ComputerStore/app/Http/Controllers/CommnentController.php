<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Mockery\Undefined;

class CommnentController extends Controller
{
    private $base;
    const table = 'comment';
    const id = 'comment_id';
    const product_id = 'product_id';
    const account_id = 'account_id';
    const parentCommentId = "parentCommentId";
    const rate = "rate";
    const comment_content = 'comment_content';
    const status = "status";
    const created_at = 'created_at';

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
        $objs = null;
        $code = null;
        $objs = DB::table(self::table)
            ->join(ProductController::table, self::table . '.' . self::product_id, '=', ProductController::table . '.' . ProductController::id)
            ->join(AccountController::table, self::table . '.' . self::account_id, '=', AccountController::table . '.' . AccountController::id)
            ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
            ->select(self::table . '.*', ProductController::table . '.' . ProductController::product_name, AccountController::table . '.' . AccountController::full_name, AccountTypeController::table . '.' . AccountTypeController::description, AccountTypeController::table . '.' . AccountTypeController::id, AccountController::table . '.' . AccountController::image)
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
        date_default_timezone_set(BaseController::timezone);
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        $validator = Validator::make($request->all(), [
            self::comment_content => 'required',
            self::product_id => 'required',
            self::account_id => 'required',
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->all()], 400);
        }
        $obj = [];
        if ($request->parentCommentId) {
            $obj[self::parentCommentId] = $request->parentCommentId;
        }
        if ($request->rate) {
            $obj[self::rate] = $request->rate;
        }
        $obj[self::account_id] = $request->account_id;
        $obj[self::product_id] = $request->product_id;
        $obj[self::comment_content] = $request->comment_content;
        $obj[self::status] = $request->status;
        $obj[self::created_at] = date('Y-m-d h:i:s');;
        if (DB::table(self::table)->insert($obj)) {
            if ($ac_type == AccountController::KH) {
                return response()->json(['success' => 'Bạn gửi thành công.Bình luận của bạn đang chờ phê duyệt. Chúng tôi sẽ phản hồi sớm'], 201);
            } else {
                return response()->json(['success' => 'Thêm bình luận thành công'], 201);
            }
        } else {
            return response()->json(['error' => 'Thêm bình luận thất bại'], 400);
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
        $code = null;
        $objs = DB::table(self::table)
            ->join(AccountController::table, self::table . '.' . self::account_id, '=', AccountController::table . '.' . AccountController::id)
            ->select(self::table . '.*', AccountController::table . '.' . AccountController::full_name, AccountController::table . '.' . AccountController::image)
            ->where(self::table . '.' . self::product_id, '=', $id)
            ->get();
        $code = 200;
        return response()->json(['data' => $objs], $code);
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
            $rate = [];
            $rateTotal = 0;
            $productRates = DB::table(self::table)
                ->where(self::product_id, '=', $request->product_id)
                ->Where(self::status, '=', "Đã xác nhận")
                ->Where(self::rate, '>', 0)
                ->get();
            if (count($productRates) > 0) {
                foreach ($productRates as $productRate) {
                    $rateTotal += $productRate->rate;
                }
                $rate[self::rate] = $rateTotal / count($productRates);
                DB::table(ProductController::table)->where(ProductController::id, '=', $request->product_id)->update($rate);
            }
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
        try {
            if ($listId = $request->get(BaseController::listId)) {
                if (count($listId) > 0) {
                    foreach ($listId as $id) {
                        $comment_childs = DB::table(self::table)->where(self::parentCommentId, '=', $id)->get(self::id);
                        foreach ($comment_childs as $comment_child) {
                            DB::table(self::table)->where(self::id, '=', $comment_child->comment_id)->delete();
                        }
                    }
                    DB::table(self::table)->where(self::id, '=', $listId)->delete();
                    return response()->json(['success' => 'Xóa thành công'], 200);
                } else {
                    return response()->json(['error' => 'Xóa thất bại. Không có dữ liệu'], 400);
                }
            } else {
                $id = $request->get(BaseController::key_id);
                $comment_child = DB::table(self::table)->where(self::parentCommentId, '=', $id)->get(self::id);
                DB::table(self::table)->whereIn(self::id, $comment_child)->delete();
                if ($loai_tk == AccountController::NV || $loai_tk == AccountController::QT) {
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
