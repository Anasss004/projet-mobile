class Costume {
  final int? id;
  final String nom;
  final String? description;
  final String? taille;
  final double prixJournalier;
  final String statut;
  final int stock;
  final int categorieId;
  final String? imageUrl;

  Costume({
    this.id,
    required this.nom,
    this.description,
    this.taille,
    required this.prixJournalier,
    required this.statut,
    required this.stock,
    required this.categorieId,
    this.imageUrl,
  });

  factory Costume.fromJson(Map<String, dynamic> json) {
    return Costume(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      taille: json['taille'],
      prixJournalier: double.parse(json['prix_journalier'].toString()),
      statut: json['statut'],
      stock: json['stock'] ?? 0,
      categorieId: json['categorie_id'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'taille': taille,
      'prix_journalier': prixJournalier,
      'statut': statut,
      'stock': stock,
      'categorie_id': categorieId,
      'image_url': imageUrl,
    };
  }

  bool get isAvailable => stock > 0;

  Costume copyWith({
    int? id,
    String? nom,
    String? description,
    String? taille,
    double? prixJournalier,
    String? statut,
    int? stock,
    int? categorieId,
    String? imageUrl,
  }) {
    return Costume(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      taille: taille ?? this.taille,
      prixJournalier: prixJournalier ?? this.prixJournalier,
      statut: statut ?? this.statut,
      stock: stock ?? this.stock,
      categorieId: categorieId ?? this.categorieId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
