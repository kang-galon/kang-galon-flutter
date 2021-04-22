import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/location.dart' as model;
import 'package:location/location.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  Location _location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  LocationBloc() : super(LocationServiceUnable());

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    _serviceEnabled = await this._location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await this._location.requestService();
      if (!_serviceEnabled) {
        yield LocationServiceUnable();
      }
    }

    _permissionGranted = await this._location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await this._location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        yield LocationPermissionUnable();
      }
    }

    if (event is LocationCurrent) {
      LocationData locationData = await this._location.getLocation();

      Coordinates coordinates =
          Coordinates(locationData.latitude, locationData.longitude);
      List<Address> address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      yield LocationEnable(
        location: model.Location(
          address: address.first.addressLine,
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        ),
      );
    }

    if (event is LocationSet) {
      Coordinates coordinates =
          Coordinates(event.location.latitude, event.location.longitude);
      List<Address> address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      yield LocationEnable(
        location: model.Location(
          address: address.first.addressLine,
          latitude: event.location.latitude,
          longitude: event.location.longitude,
        ),
      );
    }
  }
}
