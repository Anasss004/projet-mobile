<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * Handle user login
     */
    public function login(Request $request)
    {
        try {
            $request->validate([
                'email' => 'required|email',
                'mot_de_passe' => 'required',
            ]);

            // Find user by email
            $user = User::where('email', $request->email)->first();

            // Check if user exists and password is correct
            if (!$user || !Hash::check($request->mot_de_passe, $user->password)) {
                return response()->json([
                    'message' => 'Invalid credentials'
                ], 401);
            }

            // Generate Sanctum token
            $token = $user->createToken('auth-token')->plainTextToken;

            return response()->json([
                'access_token' => $token,
                'token_type' => 'Bearer',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Database connection failed',
                'message' => 'Unable to connect to database. Please check your database configuration.',
                'details' => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }

    /**
     * Handle user registration
     */
    public function register(Request $request)
    {
        try {
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|email|unique:users,email',
                'mot_de_passe' => 'required|string|min:8',
            ]);

            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->mot_de_passe),
                'role' => 'client', // New registrations are always clients
            ]);

            // Generate Sanctum token
            $token = $user->createToken('auth-token')->plainTextToken;

            return response()->json([
                'access_token' => $token,
                'token_type' => 'Bearer',
                'user' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->role ?? 'client', // Default to client for new registrations
                ]
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Database connection failed',
                'message' => 'Unable to connect to database. Please check your database configuration.',
                'details' => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }
}

