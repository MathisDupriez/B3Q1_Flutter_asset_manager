import '../../Model/asset.dart';

abstract class AssetState {}

class AssetInitial extends AssetState {}

class AssetsLoaded extends AssetState {
  final List<Asset> currentAssets;

  AssetsLoaded(this.currentAssets);  
}
