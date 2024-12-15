import 'asset.dart';

class AppAsset extends Asset {
  final String path;

  AppAsset(super.id, super.name, super.description, this.path);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'AppAsset',
      'id': id,
      'name': name,
      'description': description,
      'path': path,
    };
  }

  factory AppAsset.fromMap(Map<String, dynamic> map) {
    return AppAsset(
      map['id'],
      map['name'],
      map['description'],
      map['path'],
    );
  }
}
