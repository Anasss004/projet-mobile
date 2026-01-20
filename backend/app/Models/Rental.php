<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rental extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'costume_id',
        'start_date',
        'end_date',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'start_date' => 'date',
            'end_date' => 'date',
        ];
    }

    /**
     * Get the user that owns the rental
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the costume that is rented
     */
    public function costume()
    {
        return $this->belongsTo(Costume::class);
    }
}
