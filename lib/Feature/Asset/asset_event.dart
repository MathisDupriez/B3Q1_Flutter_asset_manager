import 'package:b3q1_flutter_project_asset_manager/Model/location.dart';
import 'package:flutter/material.dart';

import '../../Model/asset.dart';


abstract class AssetEvent {}

class SetAssetEvent extends AssetEvent {
  final List<Asset> assets;
  final Location location;
  SetAssetEvent(this.assets,this.location){
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


class goDownEvent extends AssetEvent {
  final int id;
  goDownEvent(this.id);
}

class goUpEvent extends AssetEvent {

  goUpEvent();
}