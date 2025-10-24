<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Support\Facades\Log;

class TestFrequentJob implements ShouldQueue
{
    use Dispatchable, Queueable;

    protected $job_id;

    public function __construct($job_id) {
        $this->job_id = $job_id;
    }
    public function handle()
    {
        context([
            'queue' => 'frequent_256mb_1hr',
            'job_id' => $this->job_id
        ]);

        Log::info("Running TestFrequentJob on process " . getmypid());
        sleep(rand(0, 100)); // Simulate some work
        Log::info("Finished TestFrequentJob on process " . getmypid());
    }
}
