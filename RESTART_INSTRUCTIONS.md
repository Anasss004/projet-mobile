# How to Restart the Backend with New Changes

## Steps to Restart:

### 1. Stop the Current Server
- If it's running in a terminal, press `Ctrl+C` to stop it

### 2. Clear Laravel Caches (Important!)
Run these commands to ensure all changes are loaded:

```bash
cd backend
php artisan config:clear
php artisan route:clear
php artisan cache:clear
```

### 3. Restart the Server
```bash
php artisan serve
```

### 4. Verify It's Working
Open a browser and test:
- http://localhost:8000/api/test
- http://localhost:8000/api/costumes

## Why Restart is Needed:

We made changes to:
- ✅ `bootstrap/app.php` (added API routes loading) - **REQUIRES RESTART**
- ✅ `config/cors.php` (new CORS config) - **REQUIRES CONFIG CLEAR + RESTART**
- ✅ `app/Models/Costume.php` (fixed model) - No restart needed, but good to clear cache
- ✅ Routes and controllers - **REQUIRES RESTART**

## Quick Command Sequence:

```bash
# Stop server (Ctrl+C if running)

cd backend
php artisan config:clear
php artisan route:clear  
php artisan cache:clear
php artisan serve
```

Then test the mobile app again!

