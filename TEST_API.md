# Testing the API

Use these steps to verify the API is working correctly:

## 1. Check if Backend is Running

Open a browser or use curl:
```bash
# Browser: Visit http://localhost:8000/api/test
# Should return: {"status":"API OK"}

# Or use curl:
curl http://localhost:8000/api/test
```

## 2. Test Costumes Endpoint

```bash
curl http://localhost:8000/api/costumes
```

**Expected responses:**
- If database is empty: `[]` (empty array)
- If there are costumes: JSON array with costume objects
- If error: Error message

## 3. Common Issues

### Issue: "Connection refused" or "Failed to load"
**Solution:** Make sure the backend server is running:
```bash
cd backend
php artisan serve
```

### Issue: Empty array `[]`
**Solution:** The database is empty. You need to add some costumes. You can:
1. Use Laravel Tinker to add test data
2. Create a seeder
3. Use the API to create costumes (if you implement the store method)

### Issue: 404 Not Found
**Solution:** Check that:
- API routes are loaded (we fixed this in bootstrap/app.php)
- The route exists in routes/api.php
- You're using the correct URL: `http://localhost:8000/api/costumes`

### Issue: 500 Internal Server Error
**Solution:** Check Laravel logs:
```bash
cd backend
tail -f storage/logs/laravel.log
```

## 4. Add Test Data (Optional)

If the database is empty, you can add test costumes using Laravel Tinker:

```bash
cd backend
php artisan tinker
```

Then in tinker:
```php
use App\Models\Costume;
use App\Models\Categorie;

// Create a category first (if needed)
$cat = Categorie::create(['nom' => 'Superhero', 'description' => 'Superhero costumes']);

// Create a costume
Costume::create([
    'nom' => 'Superman',
    'description' => 'Classic Superman costume',
    'prix_journalier' => 25.00,
    'taille' => 'M',
    'statut' => 'Disponible',
    'categorie_id' => $cat->id
]);
```

## 5. Mobile App Connection

For the mobile app to connect:
- **Android Emulator**: Use `http://10.0.2.2:8000/api` (already configured)
- **iOS Simulator**: Use `http://localhost:8000/api`
- **Physical Device**: Use your computer's IP address (e.g., `http://192.168.1.100:8000/api`)

To find your computer's IP:
- Windows: `ipconfig` (look for IPv4 Address)
- Mac/Linux: `ifconfig` or `ip addr`

