# Application de Location de Costumes

Une application mobile complète pour la location de costumes, composée d'un backend Laravel et d'une application mobile Flutter.

## 📱 Aperçu du Projet

Cette application permet aux utilisateurs de parcourir un catalogue de costumes, de voir les détails de chaque article et de gérer leurs locations. Le backend gère l'authentification, les données des costumes et les transactions.

## 🚀 Fonctionnalités Clés

*   **Catalogue Interactif** : Parcourez une large gamme de costumes avec des images et des prix.
*   **Détails du Produit** : Visualisez les informations détaillées, les tailles disponibles et la description.
*   **Authentification** : Système de connexion et d'inscription pour les utilisateurs.
*   **Gestion des Locations** : Suivez vos emprunts et retours.

## 📸 Interface Utilisateur

> *Veuillez ajouter une vidéo de démonstration ou des captures d'écran ici pour illustrer le fonctionnement.*

| Connexion | Catalogue | Détails |
|-----------|-----------|---------|
| ![Login](assets/login_mockup.png) | ![Catalogue](assets/catalogue_mockup.png) | ![Détails](assets/detail_mockup.png) |

## 🛠 Stack Technique

*   **Mobile** : Flutter (Dart)
*   **Backend** : Laravel (PHP)
*   **Base de données** : SQLite

## 🏁 Démarrage Rapide

Pour lancer le projet localement, vous devez exécuter le backend et l'application mobile simultanément.

### Prérequis
*   PHP 8.2+ & Composer
*   Flutter SDK
*   Android Studio / Xcode

### 1. Lancer le Backend
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```
Le serveur sera accessible sur `http://localhost:8000`.

### 2. Lancer l'Application Mobile
```bash
cd mobile
flutter pub get
flutter run
```
*Note : Sur émulateur Android, l'application est configurée pour communiquer avec le backend via `10.0.2.2`.*

---
Pour plus de détails sur l'installation, les problèmes courants et le dépannage, consultez le fichier complet [HOW_TO_RUN.md](HOW_TO_RUN.md).
