<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id('product_id');
            $table->string('product_name');
            $table->bigInteger('trademark_id');
            $table->bigInteger('product_type_id');
            $table->double('price', 15, 2)->default(0.00);
            $table->integer('amount')->default(0);
            $table->text('description');
            $table->integer('view')->default(0);
            $table->double('rate')->default(0.00);
            $table->date('created_at')->default(now());
            $table->bigInteger('createdBy');
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
        Schema::dropIfExists('products');
    }
}
