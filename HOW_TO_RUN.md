# How to Run the Project

This project consists of a **Laravel backend** and a **Flutter mobile app**. Follow these steps to run both parts.

## Prerequisites

### For Backend (Laravel):
- PHP 8.2 or higher
- Composer
- SQLite (already configured, no installation needed)

### For Mobile App (Flutter):
- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode (for mobile development)
- An Android emulator or physical device

---

## Step 1: Setup Backend (Laravel)

### 1.1 Navigate to backend directory
```bash
cd backend
```

### 1.2 Install PHP dependencies
```bash
composer install
```

### 1.3 Create .env file (if it doesn't exist)
```bash
# On Windows PowerShell:
Copy-Item .env.example .env
# Or if .env.example doesn't exist, create a basic .env file

# On Linux/Mac:
cp .env.example .env
```

If `.env.example` doesn't exist, create a `.env` file with this content:
```env
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://localhost:8000

DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite

SESSION_DRIVER=database
SESSION_LIFETIME=120
```

### 1.4 Generate application key
```bash
php artisan key:generate
```

### 1.5 Run database migrations
```bash
php artisan migrate
```

### 1.6 Start the Laravel development server
```bash
php artisan serve
```

The API will be available at: **http://localhost:8000**

**API Endpoints:**
- `GET http://localhost:8000/api/test` - Test endpoint
- `POST http://localhost:8000/api/login` - Login
- `POST http://localhost:8000/api/register` - Register
- `GET http://localhost:8000/api/costumes` - Get costumes list

---

## Step 2: Setup Mobile App (Flutter)

### 2.1 Navigate to mobile directory
```bash
cd mobile
```

### 2.2 Install Flutter dependencies
```bash
flutter pub get
```

### 2.3 Update API URL (if needed)

The mobile app is configured to use `http://10.0.2.2:8000/api` for Android emulator.
- **For Android Emulator**: Keep as is (`10.0.2.2` is the special IP to access localhost)
- **For iOS Simulator**: Change to `http://localhost:8000/api`
- **For Physical Device**: Change to your computer's IP address (e.g., `http://192.168.1.100:8000/api`)

To change the API URL, edit:
- `mobile/lib/services/api_service.dart` (line 7)
- `mobile/lib/services/costume_api_service.dart` (line 8)

### 2.4 Run the Flutter app

**For Android:**
```bash
flutter run
```

**For iOS (Mac only):**
```bash
flutter run
```

**For a specific device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

---

## Quick Start (All-in-One)

### Windows PowerShell:
```powershell
# Terminal 1 - Backend
cd backend
composer install
php artisan key:generate
php artisan migrate
php artisan serve

# Terminal 2 - Mobile App
cd mobile
flutter pub get
flutter run
```

### Linux/Mac:
```bash
# Terminal 1 - Backend
cd backend
composer install
php artisan key:generate
php artisan migrate
php artisan serve

# Terminal 2 - Mobile App
cd mobile
flutter pub get
flutter run
```

---

## Troubleshooting

### Backend Issues:

1. **"Class not found" errors:**
   ```bash
   composer dump-autoload
   ```

2. **Database errors:**
   ```bash
   php artisan migrate:fresh
   ```

3. **Permission errors (Linux/Mac):**
   ```bash
   chmod -R 775 storage bootstrap/cache
   ```

4. **Port 8000 already in use:**
   ```bash
   php artisan serve --port=8001
   ```
   Then update mobile app API URLs to use port 8001.

### Mobile App Issues:

1. **"Failed to load costumes" error:**
   - Make sure the backend is running
   - Check the API URL in the service files
   - For physical devices, ensure your phone and computer are on the same network

2. **Connection refused:**
   - Verify backend is running on `http://localhost:8000`
   - Check firewall settings
   - For Android emulator, ensure you're using `10.0.2.2` not `localhost`

3. **Flutter dependencies issues:**
   ```bash
   flutter clean
   flutter pub get
   ```

---

## Testing the API

You can test the API endpoints using:

### Browser:
- Visit: `http://localhost:8000/api/test`
- Should return: `{"status":"API OK"}`

### cURL (Command Line):
```bash
# Test endpoint
curl http://localhost:8000/api/test

# Get costumes
curl http://localhost:8000/api/costumes

# Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"mot_de_passe\":\"password123\"}"
```

### Postman or similar tools:
- Import the endpoints and test them

---

## Notes

- The backend uses SQLite database (no MySQL/PostgreSQL setup needed)
- The mobile app expects the backend to be running on port 8000
- For production, consider installing Laravel Sanctum for better authentication
- Make sure both backend and mobile app are running simultaneously

