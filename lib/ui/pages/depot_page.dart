import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    String location =
        "${_locationBloc.state.latitude}, ${_locationBloc.state.longitude}";

    _transactionBloc.add(TransactionAdd(
        clientLocation: location,
        depotPhoneNumber: widget.depot.phoneNumber,
        gallon: _gallon));
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
        return BlocConsumer<TransactionBloc, Transaction>(
          bloc: _transactionBloc,
          listener: (context, transaction) {
            if (transaction is TransactionSuccess) {
              Navigator.pop(context);
              showSnackbar(context, 'Checkout berhasil, silahkan menunggu');
            }

            if (transaction is TransactionError) {
              Navigator.pop(context);
              showSnackbar(context, 'Oops ada yang salah nih');
            }
          },
          builder: (context, transaction) {
            if (transaction is TransactionLoading) {
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
                  Text(_locationBloc.state.address),
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
                _locationBloc.state.latitude, _locationBloc.state.longitude),
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: 70.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              children: [
                HeaderBar(onPressed: _backAction, label: widget.depot.name),
                SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: Style.containerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image(
                          width: 100.0,
                          fit: BoxFit.fitWidth,
                          image: widget.depot.image == null
                              ? AssetImage('assets/images/phone.png')
                              : CachedNetworkImageProvider(widget.depot.image),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.depot.address),
                            SizedBox(height: 30.0),
                            Row(
                              children: [
                                Text(
                                  '${widget.depot.distance} km',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                RatingBar.builder(
                                  initialRating: widget.depot.rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 15.0,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {},
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  widget.depot.rating.toString(),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: Style.containerDecoration,
                  child: Row(
                    children: [
                      Text('Per galon '),
                      Text(
                        widget.depot.priceDesc,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: Style.containerDecoration,
                  child: Text(_locationBloc.state.address),
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
                        target: LatLng(
                            widget.depot.latitude, widget.depot.longitude),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HomeButton(
                            label: 'Kurang',
                            icon: Icons.remove,
                            onPressed: this._removeGallonAction,
                          ),
                          Container(
                            padding: EdgeInsets.all(20.0),
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
      ),
    );
  }
}
