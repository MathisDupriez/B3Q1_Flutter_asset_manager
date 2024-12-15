import 'package:flutter/material.dart';

import '../../Model/asset.dart';


abstract class AssetEvent {}

class SetAssetEvent extends AssetEvent {
  final List<Asset> assets;

  SetAssetEvent(this.assets){
    debugPrint(assets.toString());
  }
}

class LoadAssetsEvent extends AssetEvent {}

class AddAssetEvent extends AssetEvent {
  final Asset asset;

  AddAssetEvent(this.asset);
}

class UpdateAssetEvent extends AssetEvent {
  final Asset asset;

  UpdateAssetEvent(this.asset);
}

class DeleteAssetEvent extends AssetEvent {
  final int assetId;

  DeleteAssetEvent(this.assetId);
}
