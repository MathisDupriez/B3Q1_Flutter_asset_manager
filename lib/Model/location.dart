import 'asset.dart';

class Location {
  String id;  // L'ID sera une chaîne (String) mais non requis lors de la création
  final String name;
  final String description;
  final List<Asset> assets;

  // Constructeur sans l'ID
  Location({
    this.id = '', // Valeur par défaut vide pour id
    required this.name,
    required this.description,
    required this.assets,
  });

  // Convertir l'objet Location en Map pour l'envoyer à Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'assets': assets.map((asset) => asset.toMap()).toList(),
    };
  }

  // Convertir un Map en un objet Location avec l'ID de Firebase
  factory Location.fromMap(Map<String, dynamic> map, String id) {
    return Location(
      id: id,  // L'ID récupéré depuis Firebase
      name: map['name'],
      description: map['description'],
      assets: List<Asset>.from(map['assets'].map((assetMap) => Asset.fromMap(assetMap))),
    );
  }
}
