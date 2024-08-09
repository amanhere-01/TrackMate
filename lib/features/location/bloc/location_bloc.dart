import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationEvent>((event, emit)  => emit(LocationLoading()));
    on<GetCurrentLocation>(_onLocationLoading);
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
}
