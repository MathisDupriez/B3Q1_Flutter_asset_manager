import 'asset.dart';

class FileAsset extends Asset {
  final String path;
  FileAsset(super.name,super.description,this.path);
}