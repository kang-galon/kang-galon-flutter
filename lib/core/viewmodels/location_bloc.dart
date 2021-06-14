import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/helper/map_helper.dart';
import 'package:kang_galon/core/models/location.dart' as model;
import 'package:location/location.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LocationBloc() : super(LocationServiceUnable());

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        yield LocationServiceUnable();
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        yield LocationPermissionUnable();
      }
    }

    if (event is LocationCurrent) {
      LocationData locationData = await _location.getLocation();
      String address = await MapHelper.getAddressLocation(
          locationData.latitude!, locationData.longitude!);

      yield LocationEnable(
        location: model.Location(
          address: address,
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        ),
      );
    }

    if (event is LocationSet) {
      String address = await MapHelper.getAddressLocation(
          event.location.latitude, event.location.longitude);

      yield LocationEnable(
        location: model.Location(
          address: address,
          latitude: event.location.latitude,
          longitude: event.location.longitude,
        ),
      );
    }
  }
}
