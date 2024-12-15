
import 'asset.dart';

class DirectoryAsset extends Asset {
  final List<Asset> assets;

  DirectoryAsset(super.id, super.name, super.description, this.assets);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'DirectoryAsset',
      'id': id,
      'name': name,
      'description': description,
      'assets': assets.map((asset) => asset.toMap()).toList(), // Convertir les sous-assets en Map
    };
  }

  factory DirectoryAsset.fromMap(Map<String, dynamic> map) {
    return DirectoryAsset(
      map['id'],
      map['name'],
      map['description'],
      List<Asset>.from(map['assets'].map((assetMap) => Asset.fromMap(assetMap))), // Convertir les Map en objets Asset
    );
  }
}
