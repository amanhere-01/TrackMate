class LocationModel{
  final String sharingCode;
  final String sharedUserUid;
  final String sharedUserName;
  final double longitude;
  final double latitude;

  LocationModel( { required this.sharingCode,required this.sharedUserUid,required this.sharedUserName, required this.longitude, required this.latitude});

  Map<String, dynamic> toMap(){
    return {
      'sharingCode': sharingCode,
      'sharedUserUid': sharedUserUid,
      'sharedUserName': sharedUserName,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime' : DateTime.now()
    };
  }

  factory LocationModel.fromMap(Map<String,dynamic> data){
    return LocationModel(sharingCode: data['sharingCode'], sharedUserName: data['sharedUserName'], sharedUserUid: data['sharedUserUid'], latitude: data['latitude'], longitude: data['longitude'], );
  }

}