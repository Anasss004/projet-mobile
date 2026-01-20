<?php

namespace Database\Seeders;

use App\Models\Costume;
use App\Models\Categorie;
use Illuminate\Database\Seeder;

class CostumeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Créer des catégories
        $categories = [
            'Super-héros',
            'Personnages historiques',
            'Animaux',
            'Fantastique',
            'Horreur',
        ];

        foreach ($categories as $nomCategorie) {
            Categorie::firstOrCreate(['nom' => $nomCategorie]);
        }

        // Récupérer les catégories
        $categorieSuperHero = Categorie::where('nom', 'Super-héros')->first();
        $categorieHistorique = Categorie::where('nom', 'Personnages historiques')->first();
        $categorieAnimaux = Categorie::where('nom', 'Animaux')->first();
        $categorieFantastique = Categorie::where('nom', 'Fantastique')->first();
        $categorieHorreur = Categorie::where('nom', 'Horreur')->first();

        // Créer des costumes avec stock aléatoire
        $costumes = [
            [
                'nom' => 'Superman',
                'description' => 'Costume complet de Superman avec cape rouge',
                'prix_journalier' => 25.00,
                'taille' => 'M',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieSuperHero->id,
            ],
            [
                'nom' => 'Batman',
                'description' => 'Costume sombre de Batman avec masque',
                'prix_journalier' => 30.00,
                'taille' => 'L',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieSuperHero->id,
            ],
            [
                'nom' => 'Napoléon',
                'description' => 'Costume d\'époque de Napoléon Bonaparte',
                'prix_journalier' => 35.00,
                'taille' => 'M',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieHistorique->id,
            ],
            [
                'nom' => 'Panda',
                'description' => 'Costume de panda géant, doux et confortable',
                'prix_journalier' => 20.00,
                'taille' => 'XL',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieAnimaux->id,
            ],
            [
                'nom' => 'Sorcière',
                'description' => 'Costume de sorcière avec chapeau pointu',
                'prix_journalier' => 22.00,
                'taille' => 'S',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieFantastique->id,
            ],
            [
                'nom' => 'Zombie',
                'description' => 'Costume de zombie avec maquillage effrayant',
                'prix_journalier' => 28.00,
                'taille' => 'M',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieHorreur->id,
            ],
            [
                'nom' => 'Wonder Woman',
                'description' => 'Costume de Wonder Woman avec tiare',
                'prix_journalier' => 27.00,
                'taille' => 'S',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieSuperHero->id,
            ],
            [
                'nom' => 'Chevalier',
                'description' => 'Armure de chevalier médiéval',
                'prix_journalier' => 40.00,
                'taille' => 'L',
                'statut' => 'Disponible',
                'stock' => rand(0, 10),
                'categorie_id' => $categorieHistorique->id,
            ],
        ];

        foreach ($costumes as $costume) {
            Costume::firstOrCreate(
                ['nom' => $costume['nom']],
                $costume
            );
        }
    }
}
