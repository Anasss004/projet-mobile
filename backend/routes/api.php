<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\CostumeController;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\RentalController;

// Test route
Route::get('/test', function () {
    return ['status' => 'API OK'];
});

// Authentication routes (public)
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

// Protected routes (require authentication)
Route::middleware('auth:sanctum')->group(function () {
    // Public authenticated routes
    Route::get('/costumes', [CostumeController::class, 'index']);
    Route::get('/costumes/{id}', [CostumeController::class, 'show']);
    
    // Client routes
    Route::post('/rentals/request', [RentalController::class, 'requestRental']);
    Route::get('/rentals/my-rentals', [RentalController::class, 'myRentals']);
    
    // Admin routes - protected by role check in controllers
    Route::post('/costumes', [CostumeController::class, 'store']);
    Route::put('/costumes/{id}', [CostumeController::class, 'update']);
    Route::delete('/costumes/{id}', [CostumeController::class, 'destroy']);
    Route::get('/rentals', [RentalController::class, 'index']);
    Route::put('/rentals/{id}/status', [RentalController::class, 'updateStatus']);
    Route::post('/rentals/{id}/approve', [RentalController::class, 'approve']);
    Route::post('/rentals/{id}/reject', [RentalController::class, 'reject']);
    
    Route::apiResource('reservations', ReservationController::class);
});