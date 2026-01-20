<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // ...
Schema::create('costumes', function (Blueprint $table) {
    $table->id();
    $table->string('nom');
    $table->text('description')->nullable();
    $table->decimal('prix_journalier', 8, 2);
    $table->string('taille'); // Ex: S, M, L, XL
    $table->enum('statut', ['Disponible', 'Loué', 'Entretien'])->default('Disponible');
    
    // Clé étrangère vers la table categories
    $table->foreignId('categorie_id')->constrained()->onDelete('cascade'); 
    
    $table->timestamps();
});
// ...
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('costumes');
    }
};
