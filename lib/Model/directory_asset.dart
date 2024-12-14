import "asset.dart";

class DirectoryAsset extends Asset{
  final List<Asset> assets;
  DirectoryAsset(super.name,super.description,this.assets);
}