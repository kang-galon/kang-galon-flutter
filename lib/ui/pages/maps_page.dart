import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late LocationBloc _locationBloc;
  late double _latitude;
  late double _longitude;
  late Completer<GoogleMapController> _mapsController;
  late bool _isCameraMove;
  late double _cameraZoom;

  @override
  void initState() {
    // init bloc
    _locationBloc = BlocProvider.of<LocationBloc>(context);

    // set
    _mapsController = Completer();
    _isCameraMove = false;
    _cameraZoom = 20.0;

    // set current position
    LocationState locationState = _locationBloc.state;
    if (locationState is LocationEnable) {
      _latitude = locationState.location.latitude;
      _longitude = locationState.location.longitude;
    }

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();

    (await _mapsController.future).dispose();
  }

  void _changeLocation() {
    Location location =
        Location(latitude: _latitude, longitude: _longitude, address: '');
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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_latitude, _longitude),
              zoom: _cameraZoom,
            ),
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _mapsController.complete(controller),
            onCameraMove: (cameraPosition) {
              _latitude = cameraPosition.target.latitude;
              _longitude = cameraPosition.target.longitude;
            },
            onCameraMoveStarted: () {
              setState(() => _isCameraMove = true);
            },
            onCameraIdle: () {
              setState(() => _isCameraMove = false);
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on,
              size: _isCameraMove ? 60.0 : 40.0,
              color: Colors.blue.shade400,
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
