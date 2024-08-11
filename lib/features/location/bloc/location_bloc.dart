import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:track_mate/features/location/models/location_model.dart';

import '../data/location_remote_data_source.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRemoteDataSource _locationRemoteDataSource;
  LocationBloc(this._locationRemoteDataSource) : super(LocationInitial()) {
    on<LocationEvent>((event, emit)  => emit(LocationLoading()));
    on<GetCurrentLocation>(_onLocationLoading);
    on<LocationShare>(_onLocationShare);
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
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onLocationShare(LocationShare event, Emitter<LocationState> emit) async{
    try {
      _locationRemoteDataSource.shareLocation(
        LocationModel(
            sharingCode: event.sharingCode,
            uid: event.uid,
            latitude: event.latitude,
            longitude: event.longitude
        )
      );
      emit(LocationShared());
    } catch(e){
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onLocationTrack(LocationTrack event, Emitter<LocationState> emit)async {
    try{
      final res = await _locationRemoteDataSource.trackLocation(event.code);
      emit(LocationTracked(res));
    } catch(e){
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onLocationStopTracking(LocationStopTracking event, Emitter<LocationState> emit) async {
    emit(LocationInitial());
  }
}
