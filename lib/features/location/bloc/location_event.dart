part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

final class GetCurrentLocation extends LocationEvent{}

final class LocationShare extends LocationEvent{
  final String sharingCode;
  final String uid;
  final double longitude;
  final double latitude;

  LocationShare({required this.sharingCode, required this.uid, required this.longitude, required this.latitude});

}

final class LocationTrack extends LocationEvent{
  final String code;
  LocationTrack({required this.code});
}

final class LocationStopTracking extends LocationEvent{}