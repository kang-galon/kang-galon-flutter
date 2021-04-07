import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:kang_galon/core/models/location.dart' as My;
import 'package:location/location.dart';

class LocationBloc extends Bloc<My.Location, My.Location> {
  bool _serviceEnabled;
  Location _location = Location();
  PermissionStatus _permissionGranted;

  LocationBloc() : super(My.LocationServiceUnable());

  @override
  Stream<My.Location> mapEventToState(My.Location location) async* {
    _serviceEnabled = await this._location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await this._location.requestService();
      if (!_serviceEnabled) {
        yield My.LocationServiceUnable();
      }
    }

    _permissionGranted = await this._location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await this._location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        yield My.LocationPermissionUnable();
      }
    }

    if (location is My.LocationCurrent) {
      LocationData locationData = await this._location.getLocation();
      print('loc long ${locationData.latitude}');
      print('loc long ${locationData.longitude}');

      Coordinates coordinates =
          Coordinates(locationData.latitude, locationData.longitude);
      List<Address> address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      yield My.LocationEnable(
        address: address.first.addressLine,
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
    }

    if (location is My.LocationSet) {
      Coordinates coordinates =
          Coordinates(location.latitude, location.longitude);
      List<Address> address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      yield My.LocationEnable(
        address: address.first.addressLine,
        latitude: location.latitude,
        longitude: location.longitude,
      );
    }
  }
}
