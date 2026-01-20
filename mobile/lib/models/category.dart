class Category {
  final int id;
  final String nom;

  Category({required this.id, required this.nom});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nom: json['nom'],
    );
  }
}
