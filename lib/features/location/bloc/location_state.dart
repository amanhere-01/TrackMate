part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState{}

final class LocationLoaded extends LocationState{
  final Position position;
  LocationLoaded(this.position);
}

final class LocationError extends LocationState{
  final String message;
  LocationError(this.message);
}

final class LocationSharing extends LocationState {
  final double latitude;
  final double longitude;

  LocationSharing({required this.latitude, required this.longitude});

}

final class LocationTracking extends LocationState{
  final LocationModel locationModel;
  LocationTracking(this.locationModel);
}

