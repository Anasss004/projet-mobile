# Class Diagram

This diagram visualizes the architecture of the **Costume Rental System**, separating the **Flutter Mobile App** from the **Laravel Backend**.

It highlights how data flows from the backend database to the mobile application's local storage and UI.

```mermaid
classDiagram
    direction TB

    namespace Mobile_App_Flutter {
        class Costume {
            +int id
            +String nom
            +String description
            +String taille
            +double prixJournalier
            +String statut
            +int stock
            +int categorieId
            +String imageUrl
            +bool isAvailable
            +copyWith() Costume
            +fromJson(Map) Costume
            +toMap() Map
        }

        class Category {
            +int id
            +String nom
            +fromJson(Map) Category
        }

        class AppState {
            -List~Costume~ _costumes
            -String? _token
            -bool _isLoading
            +bool isAuthenticated
            +login(email, password) Future~bool~
            +fetchCostumes() Future~void~
        }

        class CostumeApiService {
            +String baseUrl
            +fetchCostumes() Future~List~Costume~~
        }

        class AuthService {
            +String baseUrl
            +login(email, password) Future~String?~
            +logout()
            +getToken() Future~String?~
            +initAuth()
        }

        class DatabaseHelper {
            -Database _database
            +initDB()
            +insertCostume(Costume)
            +readAllCostumes() Future~List~Costume~~
        }
    }

    namespace Backend_Laravel {
        class User {
            +id
            +name
            +email
            +password
            +role
        }

        class Rental {
            +id
            +user_id
            +costume_id
            +start_date
            +end_date
            +status
            +total_price
        }

        class API_Endpoints {
            GET /api/costumes
            POST /api/login
            GET /api/rentals
            POST /api/rentals
        }
    }

    %% Relationships within Mobile
    AppState --> CostumeApiService : Calls API
    AppState --> DatabaseHelper : Caches Data
    AppState --> AuthService : Manages Session
    CostumeApiService ..> Costume : Creates List of
    DatabaseHelper ..> Costume : Stores/Retrieves
    Costume "*"--"1" Category : Linked by categorieId

    %% Cross-System Relationships via Network
    CostumeApiService ..> API_Endpoints : HTTP Request (JSON)
    AuthService ..> API_Endpoints : HTTP Request (Auth)

    %% Backend Relationships
    API_Endpoints ..> User : Authenticates
    API_Endpoints ..> Rental : Returns Data
```
