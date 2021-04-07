class Location {
  String address;
  double latitude;
  double longitude;

  Location({this.address, this.latitude, this.longitude});
}

class LocationSet extends Location {
  LocationSet({double latitude, double longitude})
      : super(latitude: latitude, longitude: longitude);
}

class LocationEnable extends Location {
  LocationEnable({String address, double latitude, double longitude})
      : super(address: address, latitude: latitude, longitude: longitude);
}

class LocationUnable extends Location {}

class LocationCurrent extends Location {}

class LocationServiceUnable extends Location {
  @override
  String toString() {
    return 'Silahkan aktifkan service lokasi';
  }
}

class LocationPermissionUnable extends Location {
  @override
  String toString() {
    return 'Silahkan izinkan lokasi';
  }
}
