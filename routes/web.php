<?php

use App\Jobs\TestFrequentJob;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/test-frequent', function () {
    for ($i = 0; $i < (request()->n ?: 10); $i++) {
        TestFrequentJob::dispatch(now() -> toString() . "--" . $i)->onQueue(request()->queue ?: 'default');
    }
    return 'Dispatched 100 frequent jobs!';
});
