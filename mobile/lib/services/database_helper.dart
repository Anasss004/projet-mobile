import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/costume.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('costumes_v3.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const realType = 'REAL';
    const integerType = 'INTEGER';

    await db.execute('''
CREATE TABLE costumes ( 
  id $idType, 
  nom $textType NOT NULL,
  description $textType,
  taille $textType,
  prix_journalier $realType,
  statut $textType,
  categorie_id $integerType,
  image_url $textType
  )
''');

    await _seedDB(db);
  }

  Future<void> _seedDB(Database db) async {
    // Exemple de données initiales (modifiez ici pour changer les images par défaut)
    await db.insert('costumes', {
      'nom': 'Super Héros',
      'description': 'Costume classique de super héros avec cape.',
      'taille': 'M',
      'prix_journalier': 20.0,
      'statut': 'Disponible',
      'stock': 5,
      'categorie_id': 1,
      'image_url': 'assets/images/suit1.jpeg', // Changez ceci
    });
    
     await db.insert('costumes', {
      'nom': 'Princesse',
      'description': 'Robe rose élégante.',
      'taille': 'S',
      'prix_journalier': 25.0,
      'statut': 'Disponible',
      'stock': 3,
      'categorie_id': 1,
      'image_url': 'assets/images/suit2.jpeg',
    });

    await db.insert('costumes', {
      'nom': 'Pirate',
      'description': 'Costume de pirate avec chapeau.',
      'taille': 'L',
      'prix_journalier': 22.0,
      'statut': 'Disponible',
      'stock': 4,
      'categorie_id': 1,
      'image_url': 'assets/images/suit3.jpeg',
    });

    await db.insert('costumes', {
      'nom': 'Dinosaure',
      'description': 'Costume gonflable drôle.',
      'taille': 'XL',
      'prix_journalier': 30.0,
      'statut': 'Disponible',
      'stock': 2,
      'categorie_id': 1,
      'image_url': 'assets/images/suit4.jpeg',
    });
  }

  Future<void> insertCostume(Costume costume) async {
    final db = await instance.database;
    await db.insert('costumes', costume.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Costume>> readAllCostumes() async {
    final db = await instance.database;
    final result = await db.query('costumes');

    return result.map((json) => Costume.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
