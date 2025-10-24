<?php

use App\Jobs\TestFrequentJob;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/test-frequent', function () {
    for ($i = 0; $i < (request()->n ?: 10); $i++) {
        TestFrequentJob::dispatch(now() -> toString() . "--" . $i)->onQueue(request()->queue ?: [
            'default',
            'default_priority',
            'heavy_priority_1gb_3hr',
            'heavy_1gb_3hr',
            'long_priority_512mb_12hr',
            'long_512mb_1hr'
        ][rand(0,5)]);
    }
    return 'Dispatched 100 frequent jobs!';
});
