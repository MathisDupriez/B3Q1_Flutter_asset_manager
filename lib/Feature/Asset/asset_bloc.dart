import 'package:b3q1_flutter_project_asset_manager/Model/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/asset.dart';
import '../../Model/directory_asset.dart';
import 'asset_event.dart';
import 'asset_state.dart';
import '../../Repositories/location_repository.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  // Liste des assets gérée directement dans le bloc
  List<Asset> locationAssets = [];
  LocationRepository locationRepository;
  late Location currentLocation;
  var idParent = 0;
  var lastIdParent = 0;
  List<int> idParents = [];
  
  AssetBloc({required this.locationRepository}) : super(AssetInitial()) {
    on<SetAssetEvent>((event, emit) {
      locationAssets = event.assets;
      currentLocation = event.location;
      idParent = 0;
      lastIdParent = 0;
      emit(AssetsLoaded(List.of(locationAssets))); // Émettre une copie de la liste des assets
    });

    // Chargement des assets
    on<LoadAssetsEvent>((event, emit) {
      if(idParent == 0){
        emit(AssetsLoaded(List.of(locationAssets)));
      }else{
        emit(AssetsLoaded(List.of(getAssetsById(locationAssets, idParent))));
      }
    });

    // Ajout d'un nouvel asset
    on<AddAssetEvent>((event, emit) {
      if(idParent == 0){
        locationAssets.add(event.asset);
        locationRepository.updateLocation(currentLocation);
        emit(AssetsLoaded(List.of(locationAssets)));
      }else{  
        locationAssets = addAssetByIdParent(locationAssets, idParent, event.asset);
        locationRepository.updateLocation(currentLocation);
        emit(AssetsLoaded(List.of(getAssetsById(locationAssets, idParent))));
      }
    });

    // Mise à jour d'un asset
    on<UpdateAssetEvent>((event, emit) {
      if(idParent == 0){
        locationAssets = updateAssetByIdParent(locationAssets, idParent, event.asset.id, event.asset);
        locationRepository.updateLocation(currentLocation);
        emit(AssetsLoaded(List.of(locationAssets)));
      }else{
        locationAssets = updateAssetByIdParent(locationAssets, idParent, event.asset.id, event.asset);
        locationRepository.updateLocation(currentLocation);
        emit(AssetsLoaded(List.of(getAssetsById(locationAssets, idParent))));
      }
    });

    // Suppression d'un asset
    on<DeleteAssetEvent>((event, emit) {
      if(idParent == 0){
        locationAssets.removeWhere((asset) => asset.id == event.assetId);
        locationRepository.updateLocation(currentLocation);
        emit(AssetsLoaded(List.of(locationAssets)));
      }else{
        locationAssets = removeAssetByIdParent(locationAssets, idParent, event.assetId);
        locationRepository.updateLocation(currentLocation);
        emit(AssetsLoaded(List.of(getAssetsById(locationAssets, idParent))));
      }
    });

    on<goDownEvent>((event, emit) {
      idParents.add(idParent);
      idParent = event.id;
    });

    on<goUpEvent>((event, emit) {
      idParent = idParents.last;
      idParents.removeLast();
    });
  }
}

List<Asset> getAssetsById(List<Asset> assets, int id){
  for (var asset in assets) {
    if(asset is DirectoryAsset){
      if(asset.id == id){
        return asset.assets;
      }
      getAssetsById(asset.assets, id);
    }
  }
  return [];
}

List<Asset> addAssetByIdParent(List<Asset> assets, int idParent, Asset newAsset) {
  for (var asset in assets) {
    if (asset is DirectoryAsset) {
      // Si on trouve un dossier avec l'ID parent, on y ajoute le nouvel asset
      if (asset.id == idParent) {
        asset.assets.add(newAsset);  // Ajoute l'asset au dossier
        return assets;  // Retourne la liste mise à jour
      }

      // Si l'asset est un dossier, on appelle la fonction récursivement sur ses sous-assets
      var updatedAssets = addAssetByIdParent(asset.assets, idParent, newAsset);
      if (updatedAssets != asset.assets) {
        return updatedAssets;  // Retourne la liste mise à jour
      }
    }
  }

  return assets;  // Retourne la liste sans modification si l'ID parent n'a pas été trouvé
}
List<Asset> removeAssetByIdParent(List<Asset> assets, int idParent, int idToDelete) {
  for (var asset in assets) {
    if (asset is DirectoryAsset) {
      // Si on trouve un dossier avec l'ID parent, on tente de supprimer l'asset dedans
      if (asset.id == idParent) {
        asset.assets.removeWhere((childAsset) => childAsset.id == idToDelete);  // Supprime l'asset
        return assets;  // Retourne la liste mise à jour
      }

      // Si l'asset est un dossier, on appelle la fonction récursivement sur ses sous-assets
      var updatedAssets = removeAssetByIdParent(asset.assets, idParent, idToDelete);
      if (updatedAssets != asset.assets) {
        return updatedAssets;  // Retourne la liste mise à jour
      }
    }
  }

  return assets;  // Retourne la liste sans modification si l'ID parent n'a pas été trouvé
}


List<Asset> updateAssetByIdParent(
    List<Asset> assets, int idParent, int idToUpdate, Asset updatedAsset) {
  for (var asset in assets) {
    if (asset is DirectoryAsset) {
      // Si on trouve un dossier avec l'ID parent, on tente de mettre à jour l'asset dedans
      if (asset.id == idParent) {
        // Trouver l'asset à mettre à jour et le remplacer
        int index = asset.assets.indexWhere((childAsset) => childAsset.id == idToUpdate);
        if (index != -1) {
          asset.assets[index] = updatedAsset;  // Remplace l'asset par la version mise à jour
        }
        return assets;  // Retourne la liste mise à jour
      }

      // Si l'asset est un dossier, on appelle la fonction récursivement sur ses sous-assets
      var updatedAssets = updateAssetByIdParent(asset.assets, idParent, idToUpdate, updatedAsset);
      if (updatedAssets != asset.assets) {
        return updatedAssets;  // Retourne la liste mise à jour
      }
    }
  }

  return assets;  // Retourne la liste sans modification si l'ID parent n'a pas été trouvé
}
