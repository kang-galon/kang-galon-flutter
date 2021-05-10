import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class MapsPage extends StatefulWidget {
  static const String routeName = '/maps';

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final String _infoWindowTitle = 'My Position';
  final String _markerId = 'My Location';
  LocationBloc _locationBloc;
  double _latitude;
  double _longitude;
  Completer<GoogleMapController> _mapsController;
  List<Marker> _markers;

  @override
  void initState() {
    super.initState();

    _mapsController = Completer();
    _markers = <Marker>[];
    _locationBloc = BlocProvider.of<LocationBloc>(context);

    // set current position
    LocationState locationState = _locationBloc.state;
    if (locationState is LocationEnable) {
      _latitude = locationState.location.latitude;
      _longitude = locationState.location.longitude;

      _setMarkerLocation();
    }
  }

  @override
  void dispose() async {
    super.dispose();

    (await _mapsController.future).dispose();
  }

  void _setMarkerLocation() {
    LatLng latLng = LatLng(_latitude, _longitude);

    // create marker
    _markers.add(
      Marker(
        markerId: MarkerId(_markerId),
        position: latLng,
        infoWindow: InfoWindow(title: _infoWindowTitle),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );
  }

  void _changeLocation() {
    Location location = Location(latitude: _latitude, longitude: _longitude);
    LocationSet locationSet = LocationSet(location: location);
    _locationBloc.add(locationSet);

    _backAction();
  }

  void _backAction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude, _longitude),
                zoom: 20.0,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: Set<Marker>.from(_markers),
              onMapCreated: (controller) =>
                  _mapsController.complete(controller),
              onTap: (latLng) {
                setState(() {
                  _latitude = latLng.latitude;
                  _longitude = latLng.longitude;

                  _setMarkerLocation();
                });
              },
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: Icon(Icons.chevron_left),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(10.0),
                          ),
                          minimumSize:
                              MaterialStateProperty.all<Size>(Size.zero),
                          shape: MaterialStateProperty.all<CircleBorder>(
                              CircleBorder()),
                        ),
                        onPressed: () => _backAction(),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map),
                              const SizedBox(width: 5.0),
                              Text('Ubah posisi'),
                            ],
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          onPressed: () => _changeLocation(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
