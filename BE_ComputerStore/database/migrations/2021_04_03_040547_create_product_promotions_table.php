<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductPromotionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('product_promotions', function (Blueprint $table) {
            $table->id('product_promotion_id');
            $table->bigInteger('product_id');
            $table->bigInteger('promotion_date_id');
            $table->bigInteger('promotion_level');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('product_promotions');
    }
}
