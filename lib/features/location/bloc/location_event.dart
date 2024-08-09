part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

final class GetCurrentLocation extends LocationEvent{}

final class LocationShare extends LocationEvent{
  final String sharingCode;
  final String uid;
  final double latitude;
  final double longitude;

  LocationShare({required this.sharingCode, required this.uid, required this.latitude, required this.longitude});

}