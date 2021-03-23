<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBillsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('bills', function (Blueprint $table) {
            $table->id('bill_id');
            $table->bigInteger('employee_id');
            $table->bigInteger('customer_id');
            $table->bigInteger('order_type_id');
            $table->bigInteger('status_id');
            $table->date('created_at')->default(now());
            $table->double('total_money', 15, 2)->default(0.00);
            $table->double('into_money', 15, 2)->default(0.00);
           
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('bills');
    }
}
