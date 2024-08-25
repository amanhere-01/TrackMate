import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:track_mate/features/location/models/location_model.dart';

import '../data/location_remote_data_source.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRemoteDataSource _locationRemoteDataSource;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<LocationModel>? _locationStream;
  late Position _currentPosition;

  LocationBloc(this._locationRemoteDataSource) : super(LocationInitial()) {
    on<LocationEvent>((event, emit) => emit(LocationLoading()));
    on<GetCurrentLocation>(_onLocationLoading);
    on<LocationShare>(_onLocationShare);
    on<LocationStopSharing>(_onLocationStopSharing);
    on<LocationTrack>(_onLocationTrack);
    on<LocationStopTracking>(_onLocationStopTracking);
  }

  Future<void> _onLocationLoading(LocationEvent event, Emitter<LocationState> emit) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return emit(LocationError('Location services are disabled'));
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationError('Location permission is denied'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(LocationError('Location permissions are permanently denied, we cannot request permissions.'));
      }

      _currentPosition= await Geolocator.getCurrentPosition();
      emit(LocationLoaded(_currentPosition));

    } catch (e) {
        emit(LocationError("Failed to get current location: ${e.toString()}"));
    }
  }

  Future<void> _onLocationShare(LocationShare event, Emitter<LocationState> emit) async {
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );

      await _positionStreamSubscription?.cancel(); // Cancel previous subscription
      _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) async {
          if (position != null) {
            await _locationRemoteDataSource.shareLocation(
              LocationModel(
                sharingCode: event.sharingCode,
                sharedUserUid: event.sharedUserUid,
                sharedUserName: event.sharedUserName,
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            );
            emit(LocationSharing(latitude: position.latitude, longitude: position.longitude));
          } else {
            emit(LocationError('Error fetching location!'));
          }
        },
        onError: (e) {
          emit(LocationError(e.toString()));
        },
      );

      // Await the first location update (or an error)
      await _positionStreamSubscription?.asFuture();
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onLocationStopSharing(LocationStopSharing event, Emitter<LocationState> emit) async {
    await _positionStreamSubscription?.cancel();
    emit(LocationError("Location sharing stopped"));
  }

  Future<void> _onLocationTrack(LocationTrack event, Emitter<LocationState> emit) async {
    try {
      await _locationStream?.cancel();

      _locationStream = _locationRemoteDataSource.trackLocation(event.code).listen(
        (snapshot) {
          emit(LocationTracking(snapshot));
        },
        onError: (e) {
          emit(LocationError(e.toString()));
        },
      );
      // Ensures the event handler remains active
      await _locationStream?.asFuture();
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }


  Future<void> _onLocationStopTracking(LocationStopTracking event, Emitter<LocationState> emit) async {
    await _locationStream?.cancel();
    emit(LocationError("Location tracking stopped"));
  }
}
