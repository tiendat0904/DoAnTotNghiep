<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    const quy1 = [1, 2, 3];
    const quy2 = [4, 5, 6];
    const quy3 = [7, 8, 9];
    const quy4 = [10, 11, 12];

    public function checkUser()
    {
        $user = auth()->user();
        $ac_type = $user->account_type_id;
        if ($ac_type == AccountController::NV || $ac_type == AccountController::QT) {
            return true;
        } else {
            return response()->json(['error' => 'Tài khoản không đủ quyền truy cập'], 403);
        }
    }

    //báo cáo danh sách các sản phẩm tồn kho
    public function inventoryProduct()
    {
        if ($this->checkUser()) {
            $objs = DB::table('inventoryProducts')->get();
            return response()->json(['data' => $objs], 200);
        }
    }

    //báo cáo danh sách phiếu nhập và tổng tiền nhập hàng theo tháng, quý, năm
    public function reportCoupons(Request $request)
    {
        if ($this->checkUser()) {
            $key = $request->get('key');
            $params = null;
            try {
                $param = $request->get('param');
                if (str_contains($param, '/')) {
                    $params = explode('/', $param);
                } elseif (str_contains($param, '-')) {
                    $params = explode('-', $param);
                } else {
                    $params = $param;
                }
            } catch (\Throwable $e) {
            }
            $objs = null;
            $code = 200;
            try {
                switch ($key) {
                    case 'all':
                        $objs = DB::table(CouponController::table)
                            ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                            ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                            ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                            ->orderByDesc('total_money')
                            ->get();
                        break;
                    case 'bct':
                        $objs = DB::table(CouponController::table)
                            ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                            ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                            ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                            ->whereMonth(CouponController::table. '.' . CouponController::created_at, '=', $params[0])
                            ->whereYear(CouponController::table. '.' . CouponController::created_at, '=', $params[1])
                            ->orderByDesc('total_money')
                            ->get();
                        break;
                    case 'bcq':
                        switch ($params[0]) {
                            case '1':
                                $objs = DB::table(CouponController::table)
                                    ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                                    ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                    ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '>=', self::quy1[0])
                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '<=', self::quy1[2])
                                    ->whereYear(CouponController::table. '.' . CouponController::created_at, '=', $params[1])
                                    ->orderByDesc('total_money')
                                    ->get();
                                break;
                            case '2':
                                $objs = DB::table(CouponController::table)
                                    ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                                    ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                    ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '>=', self::quy2[0])
                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '<=', self::quy2[2])
                                    ->whereYear(CouponController::table. '.' . CouponController::created_at, '=', $params[1])
                                    ->orderByDesc('total_money')
                                    ->get();
                                break;
                            case '3':
                                $objs = DB::table(CouponController::table)
                                    ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                                    ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                    ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')

                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '>=', self::quy3[0])
                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '<=', self::quy3[2])
                                    ->whereYear(CouponController::table. '.' . CouponController::created_at, '=', $params[1])
                                    ->orderByDesc('total_money')
                                    ->get();
                                break;
                            case '4':
                                $objs = DB::table(CouponController::table)
                                    ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                                    ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                    ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')

                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '>=', self::quy4[0])
                                    ->whereMonth(CouponController::table. '.' . CouponController::created_at, '<=', self::quy4[2])
                                    ->whereYear(CouponController::table. '.' . CouponController::created_at, '=', $params[1])
                                    ->orderByDesc('total_money')
                                    ->get();
                                break;
                        }
                        break;
                    case 'bcn':
                        $objs = DB::table(CouponController::table)
                            ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                            ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                            ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                            ->whereYear(CouponController::table. '.' . CouponController::created_at, '=', $params)
                            ->orderByDesc('total_money')
                            ->get();
                        break;
                    default:
                        $objs = DB::table(CouponController::table)
                            ->leftJoin(SupplierController::table, SupplierController::table . '.' . SupplierController::id, '=', CouponController::table . '.' . CouponController::supplier_id)
                            ->leftJoin(AccountController::table, CouponController::table . '.' . CouponController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                            ->select(CouponController::table . '.*', SupplierController::table . '.' . SupplierController::supplier_name, AccountController::table . '.' . AccountController::full_name . ' as employee_name')
                            ->orderByDesc('total_money')
                            ->get();
                        break;
                }
                return response()->json(['data' => $objs], $code);
            } catch (\Throwable $e) {
                return response()->json(['data' => []], 200);
            }
        }
    }

    //báo cáo danh sách hóa đơn và tổng tiền bán hàng theo tháng, quý, năm
    public function reportBills(Request $request)
    {
        if ($this->checkUser()) {
            $key = $request->get('key');
            $params = null;
            try {
                $param = $request->get('param');
                if (str_contains($param, '/')) {
                    $params = explode('/', $param);
                } elseif (str_contains($param, '-')) {
                    $params = explode('-', $param);
                } else {
                    $params = $param;
                }
            } catch (\Throwable $e) {
            }
            $objs = null;
            $code = 200;
            try {
                switch ($key) {
                    case 'all':
                        $objs = DB::table(BillController::table)
                            ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                            ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                            ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                            ->orderByDesc('into_money')
                            ->get();
                        break;
                    case 'bct':
                        $objs = DB::table(BillController::table)
                            ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                            ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                            ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                            ->whereMonth(BillController::table. '.' . BillController::created_at, '=', $params[0])
                            ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                            ->orderByDesc('into_money')
                            ->get();
                        break;
                    case 'bcq':
                        switch ($params[0]) {
                            case '1':
                                $objs = DB::table(BillController::table)
                                    ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                                    ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                                    ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy1[0])
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy1[2])
                                    ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                    ->orderByDesc('into_money')
                                    ->get();
                                break;
                            case '2':
                                $objs = DB::table(BillController::table)
                                    ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                                    ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                                    ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy2[0])
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy2[2])
                                    ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                    ->orderByDesc('into_money')
                                    ->get();
                                break;
                            case '3':
                                $objs = DB::table(BillController::table)
                                    ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                                    ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                                    ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy3[0])
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy3[2])
                                    ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                    ->orderByDesc('into_money')
                                    ->get();
                                break;
                            case '4':
                                $objs = DB::table(BillController::table)
                                    ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                                    ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                                    ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy4[0])
                                    ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy4[2])
                                    ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                    ->orderByDesc('into_money')
                                    ->get();
                                break;
                        }
                        break;
                    case 'bcn':
                        $objs = DB::table(BillController::table)
                            ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                            ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                            ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                            ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params)
                            ->orderByDesc('into_money')
                            ->get();
                        break;
                    default:
                        $objs = DB::table(BillController::table)
                            ->leftJoin(OrderTypeController::table, OrderTypeController::table . '.' . OrderTypeController::id, '=', BillController::table . '.' . BillController::order_type_id)
                            ->leftJoin(OrderStatusController::table, OrderStatusController::table . '.' . OrderStatusController::id, '=', BillController::table . '.' . BillController::order_status_id)
                            ->select(BillController::id, OrderStatusController::table . '.' . OrderStatusController::description . ' as order_status_description', OrderTypeController::table . '.' . OrderTypeController::description . ' as order_type_description', BillController::into_money, BillController::created_at)
                            ->orderByDesc('into_money')
                            ->get();
                        break;
                }
                return response()->json(['data' => $objs], $code);
            } catch (\Throwable $e) {
                return response()->json(['data' => []], 200);
            }
        }
    }

    //báo cáo danh sách họ tên, tổng tiền của từng nhân viên bán hàng theo tháng, quý, năm
    public function reportEmployees(Request $request)
    {
        if ($this->checkUser()) {
            $key = $request->get('key');
            $params = null;
            try {
                $param = $request->get('param');
                if (str_contains($param, '/')) {
                    $params = explode('/', $param);
                } elseif (str_contains($param, '-')) {
                    $params = explode('-', $param);
                } else {
                    $params = $param;
                }
            } catch (\Throwable $e) {
            }
            $objs = null;
            $code = 200;

            switch ($key) {
                case 'all':
                    $objs = DB::table(AccountController::table)
                        ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                        ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                        ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                        ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                        ->groupBy(AccountController::id)
                        ->orderByDesc('total_money1')
                        ->get();
                    break;
                case 'bct':
                    $objs = DB::table(AccountController::table)
                        ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                        ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                        ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                        ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                        ->whereMonth(BillController::table. '.' . BillController::created_at, '=', $params[0])
                        ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                        ->groupBy(AccountController::id)
                        ->orderByDesc('total_money1')
                        ->get();
                    break;
                case 'bcq':
                    switch ($params[0]) {
                        case '1':
                            $objs = DB::table(AccountController::table)
                                ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                                ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                                ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy1[0])
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy1[2])
                                ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                ->groupBy(AccountController::id)
                                ->orderByDesc('total_money1')
                                ->get();
                            break;
                        case '2':
                            $objs = DB::table(AccountController::table)
                                ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                                ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                                ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy2[0])
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy2[2])
                                ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                ->groupBy(AccountController::id)
                                ->orderByDesc('total_money1')
                                ->get();
                            break;
                        case '3':
                            $objs = DB::table(AccountController::table)
                                ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                                ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                                ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy3[0])
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy3[2])
                                ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                ->groupBy(AccountController::id)
                                ->orderByDesc('total_money1')
                                ->get();
                            break;
                        case '4':
                            $objs = DB::table(AccountController::table)
                                ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                                ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                                ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                                ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '>=', self::quy4[0])
                                ->whereMonth(BillController::table. '.' . BillController::created_at, '<=', self::quy4[2])
                                ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params[1])
                                ->groupBy(AccountController::id)
                                ->orderByDesc('total_money1')
                                ->get();
                            break;
                    }
                    break;
                case 'bcn':
                    $objs = DB::table(AccountController::table)
                        ->select(AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                        ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                        ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                        ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                        ->whereYear(BillController::table. '.' . BillController::created_at, '=', $params)
                        ->groupBy(AccountController::id)
                        ->orderByDesc('total_money1')
                        ->get();
                    break;
                default:
                    $objs = DB::table(AccountController::table)
                        ->select(AccountController::table . '.' . AccountController::id, AccountController::email, AccountController::full_name, AccountController::address, AccountController::phone_number, AccountController::image, AccountTypeController::table . '.' . AccountTypeController::description . ' as account_type_description', BillController::table . '.' . BillController::created_at, DB::raw('SUM(total_money) as total_money1'))
                        ->leftJoin(BillController::table, BillController::table . '.' . BillController::employee_id, '=', AccountController::table . '.' . AccountController::id)
                        ->join(AccountTypeController::table, AccountTypeController::table . '.' . AccountTypeController::id, '=', AccountController::table . '.' . AccountController::account_type_id)
                        ->where(AccountController::table . '.' . AccountController::account_type_id, '=', '2')
                        ->groupBy(AccountController::id)
                        ->orderByDesc('total_money1')
                        ->get();
                    break;
            }
            return response()->json(['data' => $objs], $code);
        }
    }
}
