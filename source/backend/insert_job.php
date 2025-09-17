<?php

use Illuminate\Support\Facades\DB;
use App\Jobs\TestJob;

DB::connection('db-queue')->table('jobs')->insert([
    'queue' => 'default', // string
    'payload' => "{}",
    'attempts' => 0,
    'reserved_at' => null,
    'available_at' => now()->timestamp,
    'created_at' => now()->timestamp,
]);
