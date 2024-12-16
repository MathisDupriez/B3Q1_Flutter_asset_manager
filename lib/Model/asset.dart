import 'app_asset.dart';
import 'directory_asset.dart';
import 'file_asset.dart';

abstract class Asset {
  final int id;
  final String name;
  final String description;
  String path = "";

  Asset(this.id, this.name, this.description);

  Map<String, dynamic> toMap();

  // Cette méthode sert à créer un objet Asset à partir d'un Map
  factory Asset.fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'DirectoryAsset':
        return DirectoryAsset.fromMap(map);
      case 'AppAsset':
        return AppAsset.fromMap(map);
      case 'FileAsset':
        return FileAsset.fromMap(map);
      default:
        throw Exception('Asset type not recognized');
    }
  }
}
