class DataModel
{
  // late String latitude,longitude;
  List <Map> rssi;


  DataModel({this.rssi});

  DataModel.fromJson(Map<String, dynamic> json)
  {
    // latitude = json['latitude'];
    // longitude = json['longitude'];
    rssi = json['rssi'];
  }

  Map <String,dynamic> toMap()
  {
    return {
      // 'latitude':latitude,
      // 'longitude':longitude,
      'rssi':rssi,
    };
  }

}
