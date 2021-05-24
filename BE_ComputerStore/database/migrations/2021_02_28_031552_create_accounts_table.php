<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

class CreateAccountsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('accounts', function (Blueprint $table) {
            $table->id('account_id');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('full_name');
            $table->string('address');
            $table->string('phone_number', 10)->default('');
            $table->string('image');
            $table->bigInteger('account_type_id')->default('3');
            $table->date('created_at')->default(now());
            $table->bigInteger('updatedBy');
            $table->date('updatedDate')->default(now());
        });

      
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('accounts');
    }
}
