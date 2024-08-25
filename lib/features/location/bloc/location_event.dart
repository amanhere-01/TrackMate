part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

final class GetCurrentLocation extends LocationEvent{}

final class LocationShare extends LocationEvent{
  final String sharingCode;
  final String sharedUserUid;
  final String sharedUserName;

  LocationShare({required this.sharingCode, required this.sharedUserUid, required this.sharedUserName});
}

final class LocationStopSharing extends LocationEvent{}

final class LocationTrack extends LocationEvent{
  final String code;
  LocationTrack({required this.code});
}

final class LocationStopTracking extends LocationEvent{}