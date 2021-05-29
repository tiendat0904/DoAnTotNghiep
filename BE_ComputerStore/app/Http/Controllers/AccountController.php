<?php

namespace App\Http\Controllers;

use App\Models\Account;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AccountController extends Controller
{
    private $base;
    const table = 'account';
    const id = 'account_id';
    const email = 'email';
    const password = 'password';
    const full_name = 'full_name';
    const address = 'address';
    const phone_number = 'phone_number';
    const image = 'image';
    const account_type_id = 'account_type_id';
    const remember_token = 'remember_token';
    const created_at = 'created_at';
    const updatedBy = "updatedBy";
    const updatedDate = "updatedDate";
    const NV = '2';
    const QT = '1';
    const KH = '3';

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
        if ($ac_type == self::NV || $ac_type == self::QT) {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->where(self::table . '.' . self::account_type_id, '=', '1')
                ->orWhere(self::table . '.' . self::account_type_id, '=', '2')
                ->orWhere(self::table . '.' . self::account_type_id, '=', '3')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } else {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->Where(self::table . '.' . self::account_type_id, '=', '3')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        }
    }


    public function getAccountByCustomer()
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == self::NV || $ac_type == self::QT) {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->Where(self::table . '.' . self::account_type_id, '=', '3')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } else {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->Where(self::table . '.' . self::account_type_id, '=', '3')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        }
    }

    public function getAccountCustomer()
    {
        //
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number,AccountTypeController::table . '.' . AccountTypeController::id, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->Where(self::table . '.' . self::account_type_id, '=', '3')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
    }

    public function getAccountOfEmployee()
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == self::NV || $ac_type == self::QT) {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number,AccountTypeController::table . '.' . AccountTypeController::id, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->Where(self::table . '.' . self::account_type_id, '=', '1')
                ->orWhere(self::table . '.' . self::account_type_id, '=', '2')
                ->get();
            $code = 200;
            return response()->json(['data' => $objs], $code);
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }


    public function getAccountEmployeeByAdmin()
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == self::QT) {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::created_at, self::email, self::full_name, self::address, self::phone_number,AccountTypeController::table . '.' . AccountTypeController::id, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->orWhere(self::table . '.' . self::account_type_id, '=', '2')
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
        $account_type_id = $user->account_type_id;
        if ($account_type_id == self::NV || $account_type_id == self::QT) {
            date_default_timezone_set(BaseController::timezone);
            $validator = Validator::make($request->all(), [
                self::email => 'required|email',
                self::password => 'required|min:8',
                self::full_name => 'required',
                self::address => 'required',
                self::phone_number => 'required',
                self::account_type_id => 'required',
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            $data = DB::table(self::table)->where(self::email, '=', $request->email)->get();
            if (count($data) > 0) {
                return response()->json(['error' => 'Username đã được đăng ký'], 400);
            }

            $array = [];
            $array[self::email] = $request->email;
            $array[self::password] =  bcrypt($request->password);
            $array[self::full_name] = $request->full_name;
            $array[self::address] = $request->address;
            $array[self::phone_number] = $request->phone_number;
            if ($request->image != null) {
                $array[self::image] = $request->image;
            }
            $array[self::account_type_id] = $request->account_type_id;
            $array[self::created_at] = date('Y-m-d h:i:s');
            DB::table(self::table)->insert($array);

            $email = $request->email;
            $ac = Account::where(self::email, $email)->first();
            $token = $ac->createToken('ComputerStore')->accessToken;
            return response()->json(['token' => $token,"success" => "Thêm mới tài khoản thành công", 'data' => $ac], 201);
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
        if ($ac_type == self::NV || $ac_type == self::QT) {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::full_name, self::email, self::address, self::phone_number, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->where(self::table . '.' . self::id, '=', $id)->first();
            if ($objs) {
                return response()->json(['data' => $objs], 200);
            } else {
                return response()->json(['error' => "Không tìm thấy"], 200);
            }
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    public function showByCustomer($id)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == self::KH) {
            $objs = DB::table(self::table)
                ->join(AccountTypeController::table, self::table . '.' . self::account_type_id, '=', AccountTypeController::table . '.' . AccountTypeController::id)
                ->select(self::id, self::full_name, self::email, self::address, self::phone_number, AccountTypeController::table . '.' . AccountTypeController::value, AccountTypeController::table . '.' . AccountTypeController::description, self::image)
                ->where(self::table . '.' . self::id, '=', $id)->first();
            if ($objs) {
                return response()->json(['data' => $objs], 200);
            } else {
                return response()->json(['error' => "Không tìm thấy"], 200);
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
    public function update(Request $request)
    {
        //
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        date_default_timezone_set(BaseController::timezone);
        if ($ac_type == self::NV || $ac_type == self::QT || $ac_type == self::KH) {
            $validator = Validator::make($request->all(), [
                self::email => 'required|email'
            ]);
            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()->all()], 400);
            }
            $ac = DB::table(self::table)->where(self::email, $request->email)->get();
            if (count($ac) == 0) {
                return response()->json(['error' => 'Email không chính xác'], 400);
            }
            $ac = $ac[0];
            $array = [];
            $array[self::email] = $request->email;
            if ($request->full_name != null) {
                $array[self::full_name] = $request->full_name;
            }
            if ($request->address != null) {
                $array[self::address] = $request->address;
            }
            if ($request->phone_number != null) {
                $array[self::phone_number] = $request->phone_number;
            }
            if ($request->image != null) {
                $array[self::image] = $request->image;
            }
            $array[self::updatedDate] = date('Y-m-d h:i:s');
            $array[self::updatedBy] =$user->account_id;
            if ($request->new_password != null && !Hash::check($request->old_password, $ac->password)) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Mật khẩu cũ không chính xác'], 400);
            } elseif ($request->new_password != null && $request->old_password != null && $request->new_password == $request->old_password) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Mật khẩu mới phải khác mật khẩu cũ'], 400);
            } elseif ($request->new_password != null && strlen($request->new_password) < 8) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Mật khẩu mới phải nhiều hơn 8 ký tự'], 400);
            } elseif ($request->new_password != null && $request->old_password != null && $request->new_password != $request->old_password && Hash::check($request->old_password, $ac->password)) {
                $array[self::password] = bcrypt($request->new_password);
            }
            if (count($array) == 1) {
                return response()->json(['error' => 'Chỉnh sửa thất bại. Thiếu thông tin'], 400);
            }
            DB::table(self::table)->where(self::email, $request->email)->update($array);
            $ac = Account::where(self::email, $request->email)->first();
            if ($request->new_password != null) {
                $token = $ac->createToken('ComputerStore')->accessToken;
                return response()->json(['token' => $token, 'data' => $ac], 200);
            }
            return response()->json(['data' => $ac], 200);
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }


    public function resetPassword(Request $request){
        $array = [];
        $array[self::email] = $request->email;
        $array[self::password] = bcrypt($request->new_password);
        $array[self::created_at] = date('Y-m-d h:i:s');
        DB::table(self::table)->where(self::email, $request->email)->update($array);
            $ac = Account::where(self::email, $request->email)->first();
            if ($request->new_password != null) {
                $token = $ac->createToken('ComputerStore')->accessToken;
                return response()->json(['token' => $token, 'data' => $ac], 200);
            }
            return response()->json(['data' => $ac], 200);
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
        if ($ac_type == self::NV || $ac_type == self::QT) {
            // try {
            //     if ($listId = $request->get(BaseController::listId)) {
            //         if (count($listId) > 0) {
            //             foreach ($listId as $id) {
            //                 if (DB::table(self::table)->where(self::table . '.' . self::account_type_id, '=', '3')
            //                     ->where(self::table . '.' . self::id, '=', $id)->get()
            //                 ) {
            //                     return response()->json(['error' => 'Xóa thất bại. Không thể xóa tài khoản khách hàng'], 403);
            //                 }
            //             }
            //         } else {
            //             return response()->json(['error' => 'Xóa thất bại. Không có dữ liệu'], 400);
            //         }
            //     } else {
            //         $id = $request->get(BaseController::key_id);
            //         if (DB::table(self::table)->where(self::table . '.' . self::account_type_id, '=', '3')
            //             ->where(self::table . '.' . self::id, '=', $id)->get()
            //         ) {
            //             return response()->json(['error' => 'Xóa thất bại. Không thể xóa tài khoản khách hàng'], 403);
            //         }
            //     }
            // } catch (\Throwable $e) {
            //     report($e);
            //     return response()->json(['error' => $e], 500);
            // }
            $this->base->destroy($request);
            return response()->json($this->base->getMessage(), $this->base->getStatus());
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    /**
     * Registration Req
     */

    public function register(Request $request)
    {
        date_default_timezone_set(BaseController::timezone);
        $validator = Validator::make($request->all(), [
            self::email => 'required',
            self::password => 'required|min:8',
            self::full_name => 'required',
            self::address => 'required',
            self::phone_number => 'required',
        ]);
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->all()], 400);
        }
        $data = DB::table(self::table)->where(self::email, '=', $request->email)->get();
        if (count($data) > 0) {
            return response()->json(['error' => 'Username đã được đăng ký'], 400);
        }

        $array = [];
        $array[self::email] = $request->email;
        $array[self::password] =  bcrypt($request->password);
        $array[self::full_name] = $request->full_name;
        $array[self::address] = $request->address;
        $array[self::phone_number] = $request->phone_number;
        if ($request->image != null) {
            $array[self::image] = $request->image;
        }
        $array[self::created_at] = date('Y-m-d h:i:s');
        DB::table(self::table)->insert($array);

        $email = $request->email;
        $ac = Account::where(self::email, $email)->first();
        $token = $ac->createToken('ComputerStore')->accessToken;
        return response()->json(['token' => $token, 'data' => $ac], 201);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            self::email => 'required',
            self::password => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->all()], 400);
        }

        $email = $request->email;

        $ac = Account::where(self::email, $email)->first();

        if ($ac) {
            if (Hash::check($request->password, $ac->password)) {
                $token = $ac->createToken('ComputerStore')->accessToken;
                return response()->json(['token' => $token, 'data' => $ac], 200);
            } else {
                return response()->json(['error' => 'Sai tài khoản hoặc mật khẩu'], 400);
            }
        } else {
            return response()->json(['error' => 'Tài khoản không tồn tại'], 401);
        }
    }

    public function userInfo()
    {
        $user = auth()->user();
        return response()->json(['data' => $user], 200);
    }

    public function logout()
    {
        if (Auth::check()) {
            Auth::user()->token()->revoke();
            return response()->json(['success' => 'logout success'], 200);
        } else {
            return response()->json(['error' => 'api.something went wrong'], 500);
        }
    }
}
