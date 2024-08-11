class SharedLocationModel{
  final String sharingCode;
  final String uid;
  final double latitude;
  final double longitude;

  SharedLocationModel( { required this.sharingCode,required this.uid, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap(){
    return {
      'sharingCode': sharingCode,
      'uid': uid,
      'latitude': latitude,
      'longitude': longitude,
      'dateTime' : DateTime.now()
    };
  }

}