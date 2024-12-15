import '../../Model/asset.dart';

abstract class AssetState {}

class AssetInitial extends AssetState {}

class AssetsLoaded extends AssetState {
  final List<Asset> assets;

  AssetsLoaded(this.assets);
}
