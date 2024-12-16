import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';
import '../../Model/location.dart';
import 'package:flutter/material.dart'; // Import to use debugPrint

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;
  late Location CurrentLocation;

  LocationBloc(this.locationRepository) : super(LocationLoading()) {
    // Charger les locations depuis le repository
    on<LoadLocations>((event, emit) async {
      emit(LocationLoading()); // État de chargement
      debugPrint('LoadLocations event triggered');

      try {
        debugPrint('Attempting to load locations...');
        final locations = await locationRepository.getLocations();
        debugPrint('Loaded locations: $locations');
        emit(LocationUpdated(locations)); // État avec les données chargées
      } catch (e) {
        debugPrint('Error loading locations: $e');
        emit(LocationError("Failed to load locations: $e")); // En cas d'erreur
      }
    });

    // Ajouter une location
    on<AddLocation>((event, emit) async {
      emit(LocationLoading()); // Indiquer le chargement
      debugPrint('AddLocation event triggered for location: ${event.location}');

      try {
        debugPrint('Attempting to add location: ${event.location}');
        await locationRepository.addLocation(event.location);
        final updatedLocations = await locationRepository.getLocations();
        debugPrint('Updated locations after add: $updatedLocations');
        emit(LocationUpdated(updatedLocations)); // État mis à jour
      } catch (e) {
        debugPrint('Error adding location: $e');
        emit(LocationError("Failed to add location: $e")); // En cas d'erreur
      }
    });

    // Supprimer une location
    on<RemoveLocation>((event, emit) async {
      emit(LocationLoading()); // Indiquer le chargement
      debugPrint('RemoveLocation event triggered for ID: ${event.id}');

      try {
        debugPrint('Attempting to remove location with ID: ${event.id}');
        await locationRepository.deleteLocation(event.id);
        final updatedLocations = await locationRepository.getLocations();
        debugPrint('Updated locations after removal: $updatedLocations');
        emit(LocationUpdated(updatedLocations)); // État mis à jour
      } catch (e) {
        debugPrint('Error removing location: $e');
        emit(LocationError("Failed to remove location: $e")); // En cas d'erreur
      }
    });

    // Mettre à jour une location
    on<UpdateLocation>((event, emit) async {
      emit(LocationLoading()); // Indiquer le chargement
      debugPrint('LocBloc event triggered for location: ${event.location}');
      try {
        debugPrint('Attempting to update location: ${event.location}');
        await locationRepository.updateLocation(event.location);
        final updatedLocations = await locationRepository.getLocations();
        debugPrint('Updated locations after update: $updatedLocations');
        emit(LocationUpdated(updatedLocations)); // État mis à jour
      } catch (e) {
        debugPrint('Error updating location: $e');
        emit(LocationError("Failed to update location: $e")); // En cas d'erreur
      }
    });
  }
}
