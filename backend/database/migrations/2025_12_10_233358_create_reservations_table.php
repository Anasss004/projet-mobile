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
Schema::create('reservations', function (Blueprint $table) {
    $table->id();
    
    // Clé étrangère vers la table users (clients)
    $table->foreignId('user_id')->constrained()->onDelete('cascade'); 
    // Clé étrangère vers la table costumes
    $table->foreignId('costume_id')->constrained()->onDelete('cascade'); 
    
    $table->date('date_debut');
    $table->date('date_fin_prevue');
    $table->date('date_retour_reel')->nullable(); // Date réelle si différent de la date prévue
    $table->decimal('montant_total', 8, 2);
    $table->enum('statut', ['Demandée', 'Confirmée', 'En cours', 'Retournée', 'Annulée'])->default('Demandée');
    
    $table->timestamps();
});
// ...
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reservations');
    }
};
