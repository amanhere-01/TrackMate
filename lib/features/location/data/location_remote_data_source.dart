import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_mate/features/location/models/location_model.dart';

abstract interface class LocationRemoteDataSource{
  Future<void> shareLocation(LocationModel sharedLocation);
  Future<LocationModel> trackLocation(String code);
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
  Future<LocationModel> trackLocation(String code) async {
    try{
      final docRef = db.collection("shared_location").doc(code);
      final docSnapshot = await docRef.get();
      if(docSnapshot.exists){
        return LocationModel.fromMap(docSnapshot.data() as Map<String,dynamic>);
      } else{
        throw Exception('Location not found for code: $code');
      }
    } catch(e){
      throw Exception(e.toString());
    }
  }


}