<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCouponsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('coupons', function (Blueprint $table) {
            $table->id('coupon_id');
            $table->string('coupon_code');
            $table->bigInteger('employee_id');
            $table->bigInteger('supplier_id');
            $table->double('total_money', 15, 2)->default(0.00);
            $table->date('created_at')->default(now());
            $table->bigInteger('updatedBy') ->nullable();
            $table->date('updatedDate')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('coupons');
    }
}
