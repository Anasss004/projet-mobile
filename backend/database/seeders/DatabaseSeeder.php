<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create or update admin user
        User::updateOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Admin User',
                'password' => bcrypt('admin123'),
                'role' => 'admin',
            ]
        );

        // Create or update client user
        User::updateOrCreate(
            ['email' => 'client@example.com'],
            [
                'name' => 'Client User',
                'password' => bcrypt('client123'),
                'role' => 'client',
            ]
        );

        // Create or update additional test user (legacy)
        User::updateOrCreate(
            ['email' => 'test@example.com'],
            [
                'name' => 'Test User',
                'password' => bcrypt('password123'),
                'role' => 'client',
            ]
        );

        // Seed costumes
        $this->call(CostumeSeeder::class);
    }
}
