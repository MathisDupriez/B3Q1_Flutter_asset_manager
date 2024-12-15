import 'asset.dart';

class FileAsset extends Asset {
  final String path;

  FileAsset(super.id, super.name, super.description, this.path);

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'FileAsset',
      'id': id,
      'name': name,
      'description': description,
      'path': path,
    };
  }

  factory FileAsset.fromMap(Map<String, dynamic> map) {
    return FileAsset(
      map['id'],
      map['name'],
      map['description'],
      map['path'],
    );
  }
}
