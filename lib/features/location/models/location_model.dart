class LocationModel{
  final String sharingCode;
  final String uid;
  final double longitude;
  final double latitude;

  LocationModel( { required this.sharingCode,required this.uid, required this.longitude, required this.latitude});

  Map<String, dynamic> toMap(){
    return {
      'sharingCode': sharingCode,
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime' : DateTime.now()
    };
  }

  factory LocationModel.fromMap(Map<String,dynamic> data){
    return LocationModel(sharingCode: data['sharingCode'], uid: data['uid'], latitude: data['latitude'], longitude: data['longitude']);
  }

}