import 'package:firebase_auth/firebase_auth.dart' as Fire;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/depot.dart';
import 'package:kang_galon/core/models/user.dart';
import 'package:kang_galon/core/models/location.dart' as My;
import 'package:kang_galon/core/viewmodels/depot_bloc.dart';
import 'package:kang_galon/core/viewmodels/location_bloc.dart';
import 'package:kang_galon/core/viewmodels/transaction_bloc.dart';
import 'package:kang_galon/core/viewmodels/user_bloc.dart';
import 'package:kang_galon/ui/pages/account_page.dart';
import 'package:kang_galon/ui/pages/maps_page.dart';
import 'package:kang_galon/ui/pages/order_page.dart';
import 'package:kang_galon/ui/widgets/depot_item.dart';
import 'package:kang_galon/ui/widgets/home_button.dart';
import 'package:kang_galon/ui/widgets/long_button.dart';

class HomePage extends StatelessWidget {
  void mapsAction(BuildContext context, LocationBloc bloc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: bloc,
            child: MapsPage(),
          ),
        ));
  }

  void detectMapsAction(LocationBloc locationBloc) {
    locationBloc.add(My.LocationCurrent());
  }

  void allDepotAction(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderPage()));
  }

  void accountAction(BuildContext context, UserBloc userBloc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: userBloc,
            child: AccountPage(),
          ),
        ));
  }

  void chatAction(BuildContext context, UserBloc userBloc) async {
    print(Fire.FirebaseAuth.instance.currentUser.uid);
    print(await Fire.FirebaseAuth.instance.currentUser.getIdToken());
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    DepotBloc depotBloc = BlocProvider.of<DepotBloc>(context);
    TransactionBloc transactionBloc = BlocProvider.of<TransactionBloc>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: 70.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2.0,
                        blurRadius: 2.0,
                        offset: Offset(1, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<UserBloc, User>(
                          builder: (context, user) =>
                              Text('Hai, ${user.name}')),
                      Divider(
                        thickness: 3.0,
                        height: 20.0,
                        color: Colors.grey.shade400,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HomeButton(
                            label: 'Riwayat',
                            icon: Icons.history,
                            onPressed: () {
                              print('Riwayat');
                            },
                          ),
                          HomeButton(
                            label: 'Akun',
                            icon: Icons.person,
                            onPressed: () =>
                                this.accountAction(context, userBloc),
                          ),
                          HomeButton(
                            label: 'Chat',
                            icon: Icons.article,
                            onPressed: () => this.chatAction(context, userBloc),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2.0,
                        blurRadius: 2.0,
                        offset: Offset(1, 2),
                      )
                    ],
                  ),
                  child: BlocBuilder<LocationBloc, My.Location>(
                    builder: (context, location) {
                      if (location is My.LocationEnable) {
                        return Column(
                          children: [
                            LongButton(
                              context: context,
                              onPressed: () =>
                                  this.mapsAction(context, locationBloc),
                              icon: Icons.map,
                              text: 'Ubah lokasi anda',
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(location.address),
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Column(
                            children: [
                              LongButton(
                                context: context,
                                onPressed: () =>
                                    this.detectMapsAction(locationBloc),
                                icon: Icons.refresh,
                                text: 'Deteksi lokasi anda',
                              ),
                              SizedBox(height: 10.0),
                              Text(location.toString()),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 30.0),
                BlocConsumer<LocationBloc, My.Location>(
                  listener: (context, location) {
                    if (location is My.LocationEnable ||
                        location is My.LocationSet) {
                      depotBloc.add(DepotFetchList(
                        latitude: location.latitude,
                        longitude: location.longitude,
                      ));
                    }
                  },
                  builder: (context, location) {
                    if (location is My.LocationEnable ||
                        location is My.LocationSet) {
                      return BlocBuilder<DepotBloc, Depot>(
                        builder: (context, depot) {
                          if (depot is DepotListSuccess) {
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2.0,
                                    blurRadius: 2.0,
                                    offset: Offset(1, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  LongButton(
                                    context: context,
                                    onPressed: () =>
                                        this.allDepotAction(context),
                                    icon: Icons.local_drink,
                                    text: 'Semua depot',
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return DepotItem(
                                        depot: depot.depots[index],
                                        locationBloc: locationBloc,
                                        transactionBloc: transactionBloc,
                                      );
                                    },
                                    itemCount: 5,
                                  ),
                                ],
                              ),
                            );
                          } else if (depot is DepotLoading) {
                            return CircularProgressIndicator();
                          } else if (depot is DepotEmpty ||
                              depot is DepotError) {
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2.0,
                                    blurRadius: 2.0,
                                    offset: Offset(1, 2),
                                  )
                                ],
                              ),
                              child: Text(
                                depot.toString(),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
