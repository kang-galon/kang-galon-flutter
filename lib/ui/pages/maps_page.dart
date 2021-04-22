import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class MapsPage extends StatelessWidget {
  final Completer<GoogleMapController> _mapsController = Completer();
  final List<Marker> _markers = <Marker>[];
  final String _infoWindowTitle = 'My Position';
  final String _markerId = 'My Location';

  void _setMarkerLocation(LocationBloc locationBloc, LatLng latLng) {
    Location location = Location(
        address: '', latitude: latLng.latitude, longitude: latLng.longitude);

    locationBloc.add(
      LocationSet(location: location),
    );

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

  void _backAction(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    double latitude = 0.0;
    double longitude = 0.0;

    LocationState locationState = locationBloc.state;
    if (locationState is LocationEnable) {
      latitude = locationState.location.latitude;
      longitude = locationState.location.longitude;
    }

    // current location
    _setMarkerLocation(locationBloc, LatLng(latitude, longitude));

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: BlocBuilder<LocationBloc, LocationState>(
              bloc: locationBloc,
              builder: (BuildContext context, state) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    zoom: 20.0,
                  ),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: Set<Marker>.from(_markers),
                  onMapCreated: (controller) =>
                      _mapsController.complete(controller),
                  onTap: (latLng) async {
                    _setMarkerLocation(locationBloc, latLng);
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: screenSize.width,
              color: Colors.transparent,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: Icon(Icons.chevron_left),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(10.0),
                            ),
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size.zero),
                            shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder()),
                          ),
                          onPressed: () => _backAction(context),
                        ),
                        ElevatedButton(
                          child: Row(
                            children: [
                              Icon(Icons.map),
                              SizedBox(width: 5.0),
                              Text('Ubah posisi'),
                            ],
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          onPressed: () => _backAction(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: screenSize.width,
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                            offset: Offset(0.0, -1.0),
                          )
                        ]),
                    child: BlocBuilder<LocationBloc, LocationState>(
                      builder: (context, event) {
                        if (event is LocationEnable) {
                          return Text(event.location.address);
                        }

                        return Text('');
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
