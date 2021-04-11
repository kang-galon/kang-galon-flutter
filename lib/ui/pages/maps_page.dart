import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon/core/models/location.dart' as My;
import 'package:kang_galon/core/viewmodels/location_bloc.dart';

class MapsPage extends StatelessWidget {
  final Completer<GoogleMapController> _mapsController = Completer();
  final List<Marker> _markers = <Marker>[];
  final String _infoWindowTitle = 'My Position';
  final String _markerId = 'My Location';

  void setMarkerLocation(LocationBloc locationBloc, LatLng latLng) {
    locationBloc.add(
      My.LocationSet(latitude: latLng.latitude, longitude: latLng.longitude),
    );

    // create marker
    this._markers.add(
          Marker(
            markerId: MarkerId(this._markerId),
            position: latLng,
            infoWindow: InfoWindow(title: this._infoWindowTitle),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    double latitude = locationBloc.state.latitude;
    double longitude = locationBloc.state.longitude;

    // current location
    this.setMarkerLocation(locationBloc, LatLng(latitude, longitude));

    return Scaffold(
      body: Container(
        child: BlocBuilder<LocationBloc, My.Location>(
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
              markers: Set<Marker>.from(this._markers),
              onMapCreated: (controller) =>
                  this._mapsController.complete(controller),
              onTap: (latLng) async {
                this.setMarkerLocation(locationBloc, latLng);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.map),
        onPressed: () {
          Navigator.pop(context);
        },
        label: Text('Ubah posisi'),
      ),
    );
  }
}
