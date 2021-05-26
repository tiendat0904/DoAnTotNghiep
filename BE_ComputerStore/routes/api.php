<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AccountController;
use App\Http\Controllers\ReportController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('register', [AccountController::class, 'register']);
Route::post('login', [AccountController::class, 'login']);



Route::post('/sendemail', [\App\Http\Controllers\MailController::class, 'sendMail']);
Route::post('/sendcode', [\App\Http\Controllers\MailController::class, 'sendCode']);

Route::get('/products', [\App\Http\Controllers\ProductController::class, 'index']);
Route::get('/products/{id}', [\App\Http\Controllers\ProductController::class, 'show']);


Route::get('/suppliers/{id}', [\App\Http\Controllers\SupplierController::class, 'show']);

Route::get('/news', [\App\Http\Controllers\NewsController::class, 'index']);

Route::put('/reset-password', [AccountController::class, 'resetPassword']);

Route::get('/brands', [\App\Http\Controllers\TrademarkController::class, 'index']);
Route::get('/brands/{id}', [\App\Http\Controllers\TrademarkController::class, 'show']);

Route::get('/comments', [\App\Http\Controllers\CommnentController::class, 'index']);
Route::get('/comments/{id}', [\App\Http\Controllers\CommnentController::class, 'show']);


Route::get('/product_type', [\App\Http\Controllers\ProductTypeController::class, 'index']);
Route::get('/product_type/{id}', [\App\Http\Controllers\ProductTypeController::class, 'show']);

Route::get('/getBill', [\App\Http\Controllers\BillController::class, 'getBill']);
Route::post('/bills_not_account', [\App\Http\Controllers\BillController::class, 'storenotaccount']);
Route::get('/bills_detail/{id}', [\App\Http\Controllers\BillDetailController::class, 'show']);
Route::post('/bills_detail_not_account', [\App\Http\Controllers\BillDetailController::class, 'storenotaccount']);
Route::get('/bills_detail_by_bill/{id}', [\App\Http\Controllers\BillDetailController::class, 'showbybill']);

Route::get('/voucher', [\App\Http\Controllers\VoucherController::class, 'index']);
Route::get('/voucher/{id}', [\App\Http\Controllers\VoucherController::class, 'show']);
Route::post('/voucher/delete', [\App\Http\Controllers\VoucherController::class, 'destroy']);

Route::middleware('auth:api')->group(function () {
    Route::get('info', [AccountController::class, 'userInfo']);
    Route::post('logout', [AccountController::class, 'logout']);


    //report
    Route::get('/reports/inventory-product', [ReportController::class, 'inventoryProduct']);
    Route::post('/reports/report-coupons', [ReportController::class, 'reportCoupons']);
    Route::post('/reports/report-bills', [ReportController::class, 'reportBills']);
    Route::post('/reports/report-employees', [ReportController::class, 'reportEmployees']);



    // tài khoản
    Route::get('/accounts', [AccountController::class, 'index']);

    Route::get('/getaccountbycustomer', [\App\Http\Controllers\AccountController::class, 'getAccountByCustomer']);

    Route::get('/getaccountofemployee', [\App\Http\Controllers\AccountController::class, 'getAccountOfEmployee']);

    Route::get('/getaccountemployeebyadmin', [\App\Http\Controllers\AccountController::class, 'getAccountEmployeeByAdmin']);

    Route::get('/accounts/{id}', [AccountController::class, 'show']);

    Route::get('/accountOfCustomer/{id}', [AccountController::class, 'showByCustomer']);

    Route::post('/accounts', [AccountController::class, 'store']);

    Route::put('/accounts', [AccountController::class, 'update']);

    Route::post('/accounts/delete', [AccountController::class, 'destroy']);


    //loại tài khoản
    Route::get('/account_type', [\App\Http\Controllers\AccountTypeController::class, 'index']);

    Route::get('/account_type/{id}', [\App\Http\Controllers\AccountTypeController::class, 'show']);

    Route::post('/account_type', [\App\Http\Controllers\AccountTypeController::class, 'store']);

    Route::put('/account_type/{id}', [\App\Http\Controllers\AccountTypeController::class, 'update']);

    Route::post('/account_type/delete', [\App\Http\Controllers\AccountTypeController::class, 'destroy']);

   

    //nhà cung cấp
    Route::get('/suppliers', [\App\Http\Controllers\SupplierController::class, 'index']);

    Route::post('/suppliers', [\App\Http\Controllers\SupplierController::class, 'store']);

    Route::put('/suppliers/{id}', [\App\Http\Controllers\SupplierController::class, 'update']);

    Route::post('/suppliers/delete', [\App\Http\Controllers\SupplierController::class, 'destroy']);


    //tin tức
    Route::post('/news', [\App\Http\Controllers\NewsController::class, 'store']);

    Route::get('/news/{id}', [\App\Http\Controllers\NewsController::class, 'show']);

    Route::put('/news/{id}', [\App\Http\Controllers\NewsController::class, 'update']);

    Route::post('/news/delete', [\App\Http\Controllers\NewsController::class, 'destroy']);


    //thương hiệu
    Route::post('/brands', [\App\Http\Controllers\TrademarkController::class, 'store']);

    Route::put('/brands/{id}', [\App\Http\Controllers\TrademarkController::class, 'update']);

    Route::post('/brands/delete', [\App\Http\Controllers\TrademarkController::class, 'destroy']);



    //Bình luận đánh giá
    Route::post('/comments', [\App\Http\Controllers\CommnentController::class, 'store']);
    Route::post('/comments/delete', [\App\Http\Controllers\CommnentController::class, 'destroy']);
    Route::put('/comments/{id}', [\App\Http\Controllers\CommnentController::class, 'update']);

    //Sản phẩm
    Route::post('/products', [\App\Http\Controllers\ProductController::class, 'store']);

    Route::put('/products/{id}', [\App\Http\Controllers\ProductController::class, 'update']);

    Route::post('/products/delete', [\App\Http\Controllers\ProductController::class, 'destroy']);


    //Loại Sản phẩm
    Route::post('/product_type', [\App\Http\Controllers\ProductTypeController::class, 'store']);

    Route::put('/product_type/{id}', [\App\Http\Controllers\ProductTypeController::class, 'update']);

    Route::post('/product_type/delete', [\App\Http\Controllers\ProductTypeController::class, 'destroy']);


    //Hình ảnh Sản phẩm
    Route::get('/product_images', [\App\Http\Controllers\ProductImageController::class, 'index']);

    Route::get('/product_images/{id}', [\App\Http\Controllers\ProductImageController::class, 'show']);

    Route::get('/product_images_by_product/{id}', [\App\Http\Controllers\ProductImageController::class, 'showbyproduct']);

    Route::post('/product_images', [\App\Http\Controllers\ProductImageController::class, 'store']);

    Route::put('/product_images', [\App\Http\Controllers\ProductImageController::class, 'update']);

    Route::post('/product_images/delete', [\App\Http\Controllers\ProductImageController::class, 'destroy']);


    //ngày khuyến mãi
    Route::get('/promotion_date', [\App\Http\Controllers\PromotionDateController::class, 'index']);

    Route::get('/promotion_date/{id}', [\App\Http\Controllers\PromotionDateController::class, 'show']);

    Route::post('/promotion_date', [\App\Http\Controllers\PromotionDateController::class, 'store']);

    Route::put('/promotion_date/{id}', [\App\Http\Controllers\PromotionDateController::class, 'update']);

    Route::post('/promotion_date/delete', [\App\Http\Controllers\PromotionDateController::class, 'destroy']);


    //khuyến mãi sản phẩm
    Route::get('/product_promotion', [\App\Http\Controllers\ProductPromotionController::class, 'index']);

    Route::get('/product_promotion/{id}', [\App\Http\Controllers\ProductPromotionController::class, 'show']);

    Route::post('/product_promotion', [\App\Http\Controllers\ProductPromotionController::class, 'store']);

    Route::put('/product_promotion/{id}', [\App\Http\Controllers\ProductPromotionController::class, 'update']);

    Route::post('/product_promotion/delete', [\App\Http\Controllers\ProductPromotionController::class, 'destroy']);


    //Trạng thái đơn hàng
    Route::get('/order_status', [\App\Http\Controllers\OrderStatusController::class, 'index']);

    Route::get('/order_status/{id}', [\App\Http\Controllers\OrderStatusController::class, 'show']);

    Route::post('/order_status', [\App\Http\Controllers\OrderStatusController::class, 'store']);

    Route::put('/order_status/{id}', [\App\Http\Controllers\OrderStatusController::class, 'update']);

    Route::post('/order_status/delete', [\App\Http\Controllers\OrderStatusController::class, 'destroy']);

    //Loại đơn
    Route::get('/order_type', [\App\Http\Controllers\OrderTypeController::class, 'index']);

    Route::get('/order_type/{id}', [\App\Http\Controllers\OrderTypeController::class, 'show']);

    Route::post('/order_type', [\App\Http\Controllers\OrderTypeController::class, 'store']);

    Route::put('/order_type/{id}', [\App\Http\Controllers\OrderTypeController::class, 'update']);

    Route::post('/order_type/delete', [\App\Http\Controllers\OrderTypeController::class, 'destroy']);

    //Hóa đơn nhập
    Route::get('/coupons', [\App\Http\Controllers\CouponController::class, 'index']);

    Route::get('/coupons/{id}', [\App\Http\Controllers\CouponController::class, 'show']);

    Route::post('/coupons', [\App\Http\Controllers\CouponController::class, 'store']);

    Route::put('/coupons/{id}', [\App\Http\Controllers\CouponController::class, 'update']);

    Route::post('/coupons/delete', [\App\Http\Controllers\CouponController::class, 'destroy']);


    // chi tiết hóa đơn nhập
    Route::get('/coupons_detail', [\App\Http\Controllers\CouponDetailController::class, 'index']);

    Route::get('/coupons_detail/{id}', [\App\Http\Controllers\CouponDetailController::class, 'show']);

    Route::post('/coupons_detail', [\App\Http\Controllers\CouponDetailController::class, 'store']);

    Route::put('/coupons_detail/{id}', [\App\Http\Controllers\CouponDetailController::class, 'update']);

    Route::post('/coupons_detail/delete', [\App\Http\Controllers\CouponDetailController::class, 'destroy']);

    // voucher
    Route::post('/voucher', [\App\Http\Controllers\VoucherController::class, 'store']);

    Route::put('/voucher/{id}', [\App\Http\Controllers\VoucherController::class, 'update']);



    // Hóa đơn bán
    Route::get('/bills', [\App\Http\Controllers\BillController::class, 'index']);
    Route::post('/bills', [\App\Http\Controllers\BillController::class, 'store']);
    Route::get('/bills/{id}', [\App\Http\Controllers\BillController::class, 'show']);
    Route::get('/billsbyaccount/{id}', [\App\Http\Controllers\BillController::class, 'showbyaccount']);
    Route::put('/bills/{id}', [\App\Http\Controllers\BillController::class, 'update']);
    Route::post('/bills/delete', [\App\Http\Controllers\BillController::class, 'destroy']);


    //chi tiết hóa đơn bán
    Route::get('/bills_detail', [\App\Http\Controllers\BillDetailController::class, 'index']); 
    Route::post('/bills_detail', [\App\Http\Controllers\BillDetailController::class, 'store']);
    Route::put('/bills_detail/{id}', [\App\Http\Controllers\BillDetailController::class, 'update']);
    Route::post('/bills_detail/delete', [\App\Http\Controllers\BillDetailController::class, 'destroy']);

    //Build cấu hình PC
    Route::get('/build_pc', [\App\Http\Controllers\BuildPCController::class, 'index']);
    Route::post('/build_pc', [\App\Http\Controllers\BuildPCController::class, 'store']);
    Route::get('/build_pc/{id}', [\App\Http\Controllers\BuildPCController::class, 'show']);
    Route::put('/build_pc/{id}', [\App\Http\Controllers\BuildPCController::class, 'update']);
    Route::post('/build_pc/delete', [\App\Http\Controllers\BuildPCController::class, 'destroy']);
});
