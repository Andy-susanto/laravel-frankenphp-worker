<?php

use Illuminate\Support\Facades\Route;


Route::get('/health', function () {
    return response()->json(['status' => 'healthy'], 200);
});

Route::get('/', function () {
   return $_SERVER['REQUEST_TIME'];
});
