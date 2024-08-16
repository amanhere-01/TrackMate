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
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<LocationModel>? _locationStream;
  LocationBloc(this._locationRemoteDataSource) : super(LocationInitial()) {
    on<LocationEvent>((event, emit)  => emit(LocationLoading()));
    on<GetCurrentLocation>(_onLocationLoading);
    on<LocationShare>(_onLocationShare);
    on<LocationStopSharing>(_onLocationStopSharing);
    on<LocationTrack>(_onLocationTrack);
    on<LocationStopTracking>(_onLocationStopTracking);
  }

  Future<void> _onLocationLoading(LocationEvent event, Emitter<LocationState> emit) async{
    try{
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
        return emit(LocationError('Location services are disabled'));
      }
      permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          emit(LocationError('Location permission is denied'));
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit (LocationError('Location permissions are permanently denied, we cannot request permissions.'));
      }

      emit(LocationLoaded(await Geolocator.getCurrentPosition()));
    } catch(e){
      emit(LocationError("Failed to get current location: ${e.toString()}"));
    }
  }

  Future<void> _onLocationShare(LocationShare event, Emitter<LocationState> emit) async{
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      );
      _positionStream?.cancel();
      _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) async{
        if(position!=null){
          print('SAHRINF LOCATION ASN POSIITON ${position.longitude}');
          await _locationRemoteDataSource.shareLocation(
              LocationModel(
                  sharingCode: event.sharingCode,
                  uid: event.uid,
                  latitude: position.latitude,
                  longitude: position.longitude
              )
          );
          emit(LocationSharing(latitude: position.latitude, longitude: position.longitude));
        } else{
          emit(LocationError('Error fetching location!'));
        }
      },
      onError: (e) {
        emit(LocationError(e.toString()));
      });
    } catch(e){
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onLocationStopSharing(LocationStopSharing event, Emitter<LocationState> emit) async {
    await _positionStream?.cancel();
    // emit(LocationInitial());
    emit(LocationError("location sahrinf stopped"));
  }

  Future<void> _onLocationTrack(LocationTrack event, Emitter<LocationState> emit)async {
    try{
      _locationStream?.cancel();
      _locationStream =  _locationRemoteDataSource.trackLocation(event.code).listen((snapshot){
        print('SAHRINF LOCATION ASN POSIITON ${snapshot.longitude}');
        emit(LocationTracking(snapshot));
      },
      onError: (e) {
        emit(LocationError(e.toString()));
      });
    } catch(e){
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onLocationStopTracking(LocationStopTracking event, Emitter<LocationState> emit) async {
    await _locationStream?.cancel();
    // emit(LocationInitial());
    emit(LocationError("location tracking stopped"));
  }
}
