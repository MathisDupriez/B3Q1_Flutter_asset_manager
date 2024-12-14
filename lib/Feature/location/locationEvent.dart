import '../../Model/location.dart';

abstract class LocationEvent {}

class LoadLocations extends LocationEvent {
  // Cet événement ne nécessite pas de paramètres.
}

class AddLocation extends LocationEvent {
  final Location location;
  AddLocation(this.location); // Prend un objet Location complet.
}

class RemoveLocation extends LocationEvent {
  final int id; // Identifiant pour supprimer une location.
  RemoveLocation(this.id);
}

class UpdateLocation extends LocationEvent {
  final Location location;
  UpdateLocation(this.location); // Prend un objet Location complet pour la mise à jour.
}
