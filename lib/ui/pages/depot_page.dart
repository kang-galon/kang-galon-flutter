import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class DepotPage extends StatefulWidget {
  final Depot depot;

  DepotPage({@required this.depot});

  @override
  _DepotPageState createState() => _DepotPageState();
}

class _DepotPageState extends State<DepotPage> {
  final List<Marker> markers = <Marker>[];
  LocationBloc _locationBloc;
  TransactionBloc _transactionBloc;
  int _gallon = 1;

  void _removeGallonAction() {
    if (_gallon != 1) {
      setState(() {
        _gallon--;
      });
    }
  }

  void _addGallonAction() {
    setState(() {
      _gallon++;
    });
  }

  void _checkoutAction() {
    LocationState locationState = _locationBloc.state;

    if (locationState is LocationEnable) {
      Location location = locationState.location;
      String clientLocation = "${location.latitude}, ${location.longitude}";

      _transactionBloc.add(TransactionAdd(
          clientLocation: clientLocation,
          depotPhoneNumber: widget.depot.phoneNumber,
          gallon: _gallon));
    }
  }

  void _backAction() {
    Navigator.pop(context);
  }

  void _orderAction() {
    int priceTotal = this._gallon * widget.depot.price;
    NumberFormat numberFormat = NumberFormat.currency(
        locale: 'en_US', symbol: 'Rp. ', decimalDigits: 0);
    String priceTotalDesc = numberFormat.format(priceTotal);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return BlocConsumer<TransactionBloc, TransactionState>(
          bloc: _transactionBloc,
          listener: (context, state) {
            if (state is TransactionAddSuccess) {
              Navigator.pop(context);
              showSnackbar(context, state.toString());
            }

            if (state is TransactionError) {
              Navigator.pop(context);
              showSnackbar(context, state.toString());
            }
          },
          builder: (context, state) {
            if (state is TransactionLoading) {
              return Container(
                height: 250,
                padding: EdgeInsets.all(20.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            }

            return Container(
              height: 250,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Alamat anda'),
                  Text(
                      (_locationBloc.state as LocationEnable).location.address),
                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 2.0,
                  ),
                  Text('Isi ulang galon'),
                  Row(
                    children: [
                      Text('${this._gallon} x ${widget.depot.priceDesc}'),
                      Spacer(),
                      Text(priceTotalDesc),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 2.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: LongButton(
                      context: context,
                      onPressed: _checkoutAction,
                      icon: Icons.bike_scooter,
                      text: 'Checkout',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // init _locationBloc
    _locationBloc = BlocProvider.of<LocationBloc>(context);

    // init _transactionBloc
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);

    // Depot marker
    this.markers.add(
          Marker(
            markerId: MarkerId(widget.depot.name),
            position: LatLng(widget.depot.latitude, widget.depot.longitude),
            infoWindow: InfoWindow(title: widget.depot.name),
          ),
        );

    // Client marker
    this.markers.add(
          Marker(
            markerId: MarkerId('Your Location'),
            position: LatLng(
              (_locationBloc.state as LocationEnable).location.latitude,
              (_locationBloc.state as LocationEnable).location.longitude,
            ),
            infoWindow: InfoWindow(title: 'Your Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Style.mainPadding,
          child: Column(
            children: [
              HeaderBar(onPressed: _backAction, label: widget.depot.name),
              SizedBox(height: 20.0),
              DepotDescription(depot: widget.depot),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20.0),
                decoration: Style.containerDecoration,
                child: Text(
                    (_locationBloc.state as LocationEnable).location.address),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: Style.containerDecoration,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(widget.depot.latitude, widget.depot.longitude),
                      zoom: 15.0,
                    ),
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    markers: Set<Marker>.from(this.markers),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width,
                decoration: Style.containerDecoration,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeButton(
                          label: 'Kurang',
                          icon: Icons.remove,
                          onPressed: this._removeGallonAction,
                          isDense: true,
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text('${this._gallon} Galon'),
                        ),
                        HomeButton(
                          label: 'Tambah',
                          icon: Icons.add,
                          onPressed: this._addGallonAction,
                          isDense: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    LongButton(
                      context: context,
                      onPressed: this._orderAction,
                      icon: Icons.shopping_cart,
                      text: 'Order isi ulang galon',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
