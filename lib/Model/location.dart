import 'asset.dart';

class Location {
  final int id;
  final String name;
  final String description;
  final List<Asset> assets;

  Location(this.id,this.name, this.description, this.assets);

  @override
  String toString() {
    return 'Location{id: $id, name: $name, description: $description, assets: $assets}';
  }
}