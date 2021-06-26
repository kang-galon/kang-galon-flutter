import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class DepotPage extends StatefulWidget {
  final Depot depot;
  DepotPage({required this.depot});

  @override
  _DepotPageState createState() => _DepotPageState();
}

class _DepotPageState extends State<DepotPage> {
  late List<Marker> _markers;
  late LocationBloc _locationBloc;
  late TransactionBloc _transactionBloc;
  late TransactionCurrentBloc _transactionCurrentBloc;
  late int _gallon;

  @override
  void initState() {
    // init bloc
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    _transactionCurrentBloc = BlocProvider.of<TransactionCurrentBloc>(context);

    // set
    _gallon = 1;

    // Depot marker
    _markers = <Marker>[];
    _markers.add(
      Marker(
        markerId: MarkerId(widget.depot.name),
        position: LatLng(widget.depot.latitude, widget.depot.longitude),
        infoWindow: InfoWindow(title: widget.depot.name),
      ),
    );

    // Client marker
    _markers.add(
      Marker(
        markerId: MarkerId('your_location'),
        position: LatLng(
          (_locationBloc.state as LocationEnable).location.latitude,
          (_locationBloc.state as LocationEnable).location.longitude,
        ),
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    super.initState();
  }

  void _removeGallonAction() {
    if (_gallon != 1) {
      setState(() => _gallon--);
    }
  }

  void _addGallonAction() {
    setState(() => _gallon++);
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

  void _orderAction() {
    int priceTotal = _gallon * widget.depot.price;
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
          listener: (context, state) {
            if (state is TransactionAddSuccess) {
              showSnackbar(context, 'Checkout berhasil, silahkan menunggu');

              // fetch current transaction
              _transactionCurrentBloc.add(TransactionFetchCurrent());

              // navigate to home
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => HomePage()),
                (route) => false,
              );
            }

            if (state is TransactionAddFailed) {
              Navigator.pop(context);

              showSnackbar(context,
                  'Checkout gagal, tunggu transaksi sebelumnya selesai');
            }
          },
          builder: (context, state) {
            if (state is TransactionLoading) {
              return Container(
                height: 250,
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const SizedBox(
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
              padding: const EdgeInsets.all(20.0),
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
                      Text('${_gallon} x ${widget.depot.priceDesc}'),
                      const Spacer(),
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: Pallette.contentPadding,
          children: [
            HeaderBar(label: widget.depot.name),
            const SizedBox(height: 20.0),
            DepotDescription(depot: widget.depot),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              decoration: Pallette.containerDecoration,
              child: Text(
                  (_locationBloc.state as LocationEnable).location.address),
            ),
            _buildDepotLocation(),
            const SizedBox(height: 20.0),
            _buildOrder(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepotLocation() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: Pallette.containerDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.depot.latitude, widget.depot.longitude),
            zoom: 15.0,
          ),
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          markers: Set<Marker>.from(_markers),
        ),
      ),
    );
  }

  Widget _buildOrder() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      decoration: Pallette.containerDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomIconButton(
                label: 'Kurang',
                icon: Icons.remove,
                onPressed: _removeGallonAction,
                isDense: true,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text('${_gallon} Galon'),
              ),
              CustomIconButton(
                label: 'Tambah',
                icon: Icons.add,
                onPressed: _addGallonAction,
                isDense: true,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          LongButton(
            context: context,
            onPressed: _orderAction,
            icon: Icons.shopping_cart,
            text: 'Order isi ulang galon',
          )
        ],
      ),
    );
  }
}
