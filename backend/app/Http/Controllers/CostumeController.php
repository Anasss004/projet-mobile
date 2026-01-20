<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Costume;


class CostumeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            // Récupère tous les costumes de la base de données
            $costumes = Costume::all();

            // Retourne la collection de costumes en format JSON
            return response()->json($costumes);
        } catch (\Exception $e) {
            // Retourne une erreur JSON au lieu d'une page d'erreur PHP
            return response()->json([
                'error' => 'Database connection failed',
                'message' => 'Unable to connect to database. Please check your database configuration.',
                'details' => config('app.debug') ? $e->getMessage() : null
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage (Admin only)
     */
    public function store(Request $request)
    {
        try {
            // Check if user is admin
            if (!auth()->user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can create costumes.'
                ], 403);
            }

            $request->validate([
                'nom' => 'required|string|max:255',
                'description' => 'nullable|string',
                'prix_journalier' => 'required|numeric|min:0',
                'taille' => 'required|string',
                'statut' => 'nullable|in:Disponible,Loué,Entretien',
                'stock' => 'required|integer|min:0',
                'categorie_id' => 'required|exists:categories,id',
            ]);

            $data = $request->all();

            if ($request->hasFile('image')) {
                $file = $request->file('image');
                $filename = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('uploads/costumes'), $filename);
                // Use the correct URL format relative to the server
                $data['image_url'] = 'http://10.0.2.2:8000/uploads/costumes/' . $filename;
            }

            $costume = Costume::create($data);

            return response()->json([
                'message' => 'Costume créé avec succès.',
                'costume' => $costume,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        try {
            $costume = Costume::findOrFail($id);
            return response()->json($costume);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Costume not found',
                'message' => $e->getMessage()
            ], 404);
        }
    }

    /**
     * Update the specified resource in storage (Admin only)
     */
    public function update(Request $request, string $id)
    {
        try {
            // Check if user is admin
            if (!auth()->user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can update costumes.'
                ], 403);
            }

            $costume = Costume::findOrFail($id);

            $request->validate([
                'nom' => 'sometimes|string|max:255',
                'description' => 'nullable|string',
                'prix_journalier' => 'sometimes|numeric|min:0',
                'taille' => 'sometimes|string',
                'statut' => 'nullable|in:Disponible,Loué,Entretien',
                'stock' => 'sometimes|integer|min:0',
                'categorie_id' => 'sometimes|exists:categories,id',
            ]);

            $data = $request->all();

            if ($request->hasFile('image')) {
                $file = $request->file('image');
                $filename = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('uploads/costumes'), $filename);
                $data['image_url'] = 'http://10.0.2.2:8000/uploads/costumes/' . $filename;
            }

            $costume->update($data);

            return response()->json([
                'message' => 'Costume mis à jour avec succès.',
                'costume' => $costume,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage (Admin only)
     */
    public function destroy(string $id)
    {
        try {
            // Check if user is admin
            if (!auth()->user()->isAdmin()) {
                return response()->json([
                    'message' => 'Unauthorized. Only admins can delete costumes.'
                ], 403);
            }

            $costume = Costume::findOrFail($id);
            $costume->delete();

            return response()->json([
                'message' => 'Costume supprimé avec succès.',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'An error occurred',
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
