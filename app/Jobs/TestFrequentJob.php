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
        $rand = mt_rand(1, 100); // 1 to 100 for percentage

        if ($rand <= 80) {
            // 80% chance: 0-5
            $x = mt_rand(0, 5);
        } elseif ($rand <= 95) {
            // Next 15% chance: 5-100
            $x = mt_rand(5, 100);
        } else {
            // Remaining 5% chance: 100-500
            $x = mt_rand(100, 500);
        }

        sleep($x); // Simulate some work
        Log::info("Finished TestFrequentJob on process " . getmypid());
    }
}
