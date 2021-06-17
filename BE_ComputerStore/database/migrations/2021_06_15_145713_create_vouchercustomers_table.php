<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateVouchercustomersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('vouchercustomers', function (Blueprint $table) {
            $table->id('voucher_customer_id');
            $table->bigInteger('voucher_id');
            $table->bigInteger('customer_id');
            $table->bigInteger('voucher_level');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('vouchercustomers');
    }
}
