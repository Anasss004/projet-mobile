# How to Add or Change Images

## 1. Using the App (Easiest)
- **Create/Edit**: Provide a URL or Pick an Image from your gallery.

## 2. Using Local Assets (Files)
1.  **Paste File**: Put your image in `mobile/assets/images/` (e.g., `batman.png`).
2.  **Restart**: Restart the app.
3.  **Link**: Edit the costume in the app and type `assets/images/batman.png` in the "URL de l'image" field.

## 3. Using Code (For Developers)
If you want to set up default images that appear when you install the app fresh:

1.  **Open File**: `mobile/lib/services/database_helper.dart`
2.  **Find Method**: Scroll to `_seedDB`.
3.  **Edit Data**: Change the `image_url` value in the code.

```dart
await db.insert('costumes', {
  'nom': 'Mon Costume',
  // ...
  'image_url': 'assets/images/mon_image.png', // <--- Changez ceci
});
```

> **Note**: This only applies when the app is installed for the first time or if you clear the app data/cache. It does not update existing data on a running app.
