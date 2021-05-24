<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class NewsController extends Controller
{
    private $base;
    const table = 'news';
    const id = 'news_id';
    const title = 'title';
    const news_content = 'news_content';
    const highlight = 'highlight';
    const thumbnail = 'thumbnail';
    const url = 'url';
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
        // $user = auth()->user();
        // $ac_type = $user->account_type_id;
        // if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
        //     $this->base->index();
        //     return response()->json($this->base->getMessage(), $this->base->getStatus());
        // } else {
        //     return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        // }
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
            date_default_timezone_set(BaseController::timezone);
            $arr_value = $request->all();
            if (count($arr_value) > 0) {
                $validator = Validator::make($arr_value, [
                    self::title => 'required',
                    self::news_content => 'required',
                    self::url => 'required'
                ]);
                if ($validator->fails()) {
                    return response()->json(['error' => $validator->errors()->all()], 400);
                }
            } else {
                return response()->json(['error' => 'Thêm mới thất bại. Không có dữ liệu'], 400);
            }

            $obj = [];
            $obj[self::title] = $request->title;
            $obj[self::news_content] = $request->news_content;
            if ($request->highlight) {
                $obj[self::highlight] = $request->highlight;
            }
            if ($request->thumbnail) {
                $obj[self::thumbnail] = $request->thumbnail;
            }
            $obj[self::url] = $request->url;
            $obj[self::created_at] = date('Y-m-d h:i:s');
            $obj[self::createdBy] = $user->account_id;

            DB::table(self::table)->insert($obj);
            return response()->json(['success' => "Thêm mới thành công"], 201);
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
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $this->base->show($id);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
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
        date_default_timezone_set(BaseController::timezone);
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            $obj = [];
            if ($request->title) {
                $obj[self::title] = $request->title;
            }
            if ($request->news_content) {
                $obj[self::news_content] = $request->news_content;
            }
            if ($request->highlight) {
                $obj[self::highlight] = $request->highlight;
            }
            if ($request->thumbnail) {
                $obj[self::thumbnail] = $request->thumbnail;
            }
            if ($request->url) {
                $obj[self::url] = $request->url;
            }
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
