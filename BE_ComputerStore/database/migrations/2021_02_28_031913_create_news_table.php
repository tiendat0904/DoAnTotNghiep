<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateNewsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('news', function (Blueprint $table) {
            $table->id('news_id');
            $table->string('title');
            $table->text('news_content');
            $table->string('highlight')->nullable();
            $table->string('thumbnail')->nullable();
            $table->string('url');
            $table->date('created_at')->nullable();
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
        Schema::dropIfExists('news');
    }
}
