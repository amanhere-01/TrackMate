import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_mate/features/location/models/location_model.dart';

abstract interface class LocationRemoteDataSource{
  Future<void> shareLocation(LocationModel sharedLocation);
  Stream<LocationModel> trackLocation(String code);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource{
  final db = FirebaseFirestore.instance;
  
  @override
  Future<void> shareLocation(LocationModel sharedLocation) async{
    try{
      final docRef = db.collection("shared_location").doc(sharedLocation.sharingCode);
      await docRef.set(sharedLocation.toMap());
    } catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Stream<LocationModel> trackLocation(String code) {
    try{
      final docRef = db.collection("shared_location").doc(code);
      return docRef.snapshots().map((snapshot){
        if(snapshot.exists){
          return LocationModel.fromMap(snapshot.data()!);
        } else {
          throw Exception('Location not found for code: $code');
        }
      });
    } catch(e){
      throw Exception(e.toString());
    }
  }
}