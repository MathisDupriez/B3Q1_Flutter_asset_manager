import '../../Model/location.dart';
abstract class LocationState {}

class LocationLoading extends LocationState {}

class LocationUpdated extends LocationState {
  final List<Location> locations;
  LocationUpdated(this.locations){
    print('LocState: $locations');
  }
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
