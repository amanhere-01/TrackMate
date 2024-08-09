import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_mate/features/location/models/shared_location_model.dart';

abstract interface class LocationRemoteDataSource{
  Future<void> shareLocation(SharedLocationModel sharedLocation);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource{
  final db = FirebaseFirestore.instance;
  
  @override
  Future<void> shareLocation(SharedLocationModel sharedLocation) async{
    try{
      final docRef = db.collection("shared_location").doc(sharedLocation.sharingCode);
      docRef.set(sharedLocation.toMap());
      final ggid = docRef.id;
      print(ggid);
    } catch(e){
      throw Exception(e.toString());
    }
  }


}