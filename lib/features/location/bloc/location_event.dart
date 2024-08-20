part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

final class GetCurrentLocation extends LocationEvent{}

final class LocationShare extends LocationEvent{
  final String sharingCode;
  final String uid;

  LocationShare({required this.sharingCode, required this.uid});
}

final class LocationStopSharing extends LocationEvent{}

final class LocationTrack extends LocationEvent{
  final String code;
  LocationTrack({required this.code});
}

final class LocationStopTracking extends LocationEvent{}