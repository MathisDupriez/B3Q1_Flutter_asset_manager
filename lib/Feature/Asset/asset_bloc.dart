import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/asset.dart';
import 'asset_event.dart';
import 'asset_state.dart';
import '../../Repositories/location_repository.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  // Liste des assets gérée directement dans le bloc
  List<Asset> assets = [];
  LocationRepository locationRepository;
  AssetBloc({required this.locationRepository}) : super(AssetInitial()) {
    on<SetAssetEvent>((event, emit) {
      assets = event.assets; // Définir la liste des assets
      emit(AssetsLoaded(List.of(assets))); // Émettre une copie de la liste des assets
    });

    // Chargement des assets
    on<LoadAssetsEvent>((event, emit) {
      emit(AssetsLoaded(List.of(assets))); // Émettre une copie de la liste des assets
    });

    // Ajout d'un nouvel asset
    on<AddAssetEvent>((event, emit) {
      assets.add(event.asset); // Ajouter l'asset
      locationRepository.updateLocationsWithoutAdding(); // Mettre à jour les locations sans ajouter de nouvelles locations
      emit(AssetsLoaded(List.of(assets))); // Réémettre la liste mise à jour
    });

    // Mise à jour d'un asset
    on<UpdateAssetEvent>((event, emit) {
      final index = assets.indexWhere((asset) => asset.id == event.asset.id);
      if (index != -1) {
        assets[index] = event.asset; // Mettre à jour l'asset
        emit(AssetsLoaded(List.of(assets))); // Réémettre la liste mise à jour
      }
    });

    // Suppression d'un asset
    on<DeleteAssetEvent>((event, emit) {
      assets.removeWhere((asset) => asset.id == event.assetId); // Supprimer l'asset
      emit(AssetsLoaded(List.of(assets))); // Réémettre la liste mise à jour
    });
  }
}
