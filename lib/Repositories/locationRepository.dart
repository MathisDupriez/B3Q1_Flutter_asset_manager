import '../Model/location.dart';
import 'package:flutter/material.dart';
import '../Model/directory_asset.dart';
import '../Model/file_asset.dart';
import '../Model/app_asset.dart';

class LocationRepository {
  final List<Location> locations = [
    Location(1, 'Location 1', 'Description 1', [
      DirectoryAsset('Directory 1', 'Description 1', [
        FileAsset('File 1', 'Description 1', 'file://'),
        FileAsset('File 2', 'Description 2', 'file://'),
        FileAsset('File 3', 'Description 3', 'file://'),
      ]),
      DirectoryAsset('Directory 2', 'Description 2', [
        FileAsset('File 4', 'Description 4', 'file://'),
        FileAsset('File 5', 'Description 5', 'file://'),
        FileAsset('File 6', 'Description 6', 'file://'),
        DirectoryAsset('Directory 3', 'Description 3', [
          FileAsset('File 7', 'Description 7', 'file://'),
          FileAsset('File 8', 'Description 8', 'file://'),
          FileAsset('File 9', 'Description 9', 'file://'),
        ]),
        AppAsset('App 1', 'Description 1', 'package://'),
        AppAsset('App 2', 'Description 2', 'package://'),
      ]),
    ]),
    Location(2, 'Location 2', 'Description 2', []),
    Location(3, 'Location 3', 'Description 3', []),
    Location(4, 'Location 4', 'Description 4', []),
    Location(5, 'Location 5', 'Description 5', []),
  ];

  LocationRepository(){
    for(int i=0; i<1000; i++){
      locations.add(Location(i, 'Location $i', 'Description $i', []));
    }
  }
  Future<List<Location>> getLocations() async {
    debugPrint("locRepo getLocations $locations");
    return List.from(locations);  // Return the updated list of locations
  }

  updateLocaltions(List<Location> locations) {
    this.locations.clear();
    this.locations.addAll(locations);
  }

  Future<List<Location>> addLocation(Location location) async {
    locations.add(location);
    return List.from(locations);  // Return the updated list of locations
  }

  Future<List<Location>> updateLocation(Location location) async {
      // Trouver l'index de la location par son ID
      for (var i = 0; i < locations.length; i++) {
        if (locations[i].id == location.id) {
          locations[i] = location;
        }
    }
    return List.from(locations);
  }





  Future<List<Location>> deleteLocation(int id) async {
    final location = locations.firstWhere((loc) => loc.id == id);
    locations.remove(location);  // Remove location from the list
    return List.from(locations);  // Return the updated list of locations
  }
}
