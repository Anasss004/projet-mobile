<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Rental;
use App\Models\Costume;
use Illuminate\Support\Facades\Auth;

class RentalController extends Controller
{
    /**
     * Create a new rental request (Client only)
     */
    public function requestRental(Request $request)
    {
        try {
            // Check if user is client
            if (!Auth::user()->isClient()) {
                return response()->json([
                    'message' => 'Unauthorized. Only clients can request rentals.'
                ], 403);
            }

            $request->validate([
                'costume_id' => 'required|exists:costumes,id',
                'start_date' => 'required|date|after_or_equal:today',
                'end_date' => 'required|date|after:start_date',
            ]);

            $costume = Costume::findOrFail($request->costume_id);

            // Check if costume is available
            if ($costume->stock <= 0) {
                return response()->json([
                    'message' => 'Ce costume n\'est plus disponible.'
                ], 400);
            }

            // Create rental request
            $rental = Rental::create([
                'user_id' => Auth::id(),
                'costume_id' => $request->costume_id,
                'start_date' => $request->start_date,
                'end_date' => $request->end_date,
                'status' => 'Pending',
            ]);

            // Decrement stock
            $costume->decrement('stock');

            return response()->json([
                'message' => 'Demande de location créée avec succès.',
                'rental' => $rental->load('costume'),
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all rentals (Admin only)
     */
    public function index()
    {
        try {
            // Check if user is admin
            if (!Auth::user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can view all rentals.'
                ], 403);
            }

            $rentals = Rental::with(['user', 'costume'])->orderBy('created_at', 'desc')->get();

            return response()->json($rentals);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get user's own rentals (Client only)
     */
    public function myRentals()
    {
        try {
            $rentals = Rental::where('user_id', Auth::id())
                ->with('costume')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json($rentals);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update rental status (Admin only)
     */
    public function updateStatus(Request $request, $id)
    {
        try {
            // Check if user is admin
            if (!Auth::user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can update rental status.'
                ], 403);
            }

            $request->validate([
                'status' => 'required|in:Pending,Confirmed,Returned,Cancelled',
            ]);

            $rental = Rental::findOrFail($id);

            $oldStatus = $rental->status;
            $rental->status = $request->status;
            $rental->save();

            // If cancelled or returned, increment stock
            if (($request->status === 'Cancelled' || $request->status === 'Returned') && $oldStatus !== 'Cancelled' && $oldStatus !== 'Returned') {
                $rental->costume->increment('stock');
            }

            return response()->json([
                'message' => 'Statut de la location mis à jour avec succès.',
                'rental' => $rental->load(['user', 'costume']),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Approve rental request (Admin only)
     */
    public function approve($id)
    {
        try {
            // Check if user is admin
            if (!Auth::user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can approve rentals.'
                ], 403);
            }

            $rental = Rental::findOrFail($id);
            
            if ($rental->status !== 'Pending') {
                return response()->json([
                    'message' => 'Cette demande ne peut plus être approuvée.'
                ], 400);
            }

            $rental->status = 'Confirmed';
            $rental->save();

            return response()->json([
                'message' => 'Demande de location approuvée avec succès.',
                'rental' => $rental->load(['user', 'costume']),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reject rental request (Admin only)
     */
    public function reject($id)
    {
        try {
            // Check if user is admin
            if (!Auth::user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can reject rentals.'
                ], 403);
            }

            $rental = Rental::findOrFail($id);
            
            if ($rental->status !== 'Pending') {
                return response()->json([
                    'message' => 'Cette demande ne peut plus être refusée.'
                ], 400);
            }

            $oldStatus = $rental->status;
            $rental->status = 'Cancelled';
            $rental->save();

            // Increment stock since rental is rejected
            $rental->costume->increment('stock');

            return response()->json([
                'message' => 'Demande de location refusée avec succès.',
                'rental' => $rental->load(['user', 'costume']),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
