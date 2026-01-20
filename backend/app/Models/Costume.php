<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Costume extends Model
{
    use HasFactory;

    protected $fillable = [
        'nom',
        'description',
        'prix_journalier',
        'taille',
        'statut',
        'stock',
        'categorie_id', // Important pour la clé étrangère
    ];

    // Définir la relation avec Categorie
    public function categorie()
    {
        return $this->belongsTo(Categorie::class);
    }
}