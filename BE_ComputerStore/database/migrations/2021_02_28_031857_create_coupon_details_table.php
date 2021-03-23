<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCouponDetailsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('coupon_details', function (Blueprint $table) {
            $table->id('coupon-detail_id');
            $table->bigInteger('coupon_id');
            $table->bigInteger("product_id");
            $table->double('price', 15, 2)->default(0.00);
            $table->integer('amount')->default(0);;
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('coupon_details');
    }
}
