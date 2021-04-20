import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/models.dart' as model;
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/history_page.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  void _mapsAction(BuildContext context, LocationBloc bloc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: bloc,
            child: MapsPage(),
          ),
        ));
  }

  void _detectMapsAction(LocationBloc locationBloc) {
    locationBloc.add(model.LocationCurrent());
  }

  void _allDepotAction(BuildContext context, DepotBloc depotBloc,
      LocationBloc locationBloc, TransactionBloc transactionBloc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<DepotBloc>.value(value: depotBloc),
            BlocProvider<LocationBloc>.value(value: locationBloc),
            BlocProvider<TransactionBloc>.value(value: transactionBloc),
          ],
          child: NearDepotPage(),
        ),
      ),
    );
  }

  void _historyAction(BuildContext context, TransactionBloc transactionBloc) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: transactionBloc,
            child: HistoryPage(),
          ),
        ));
  }

  void _accountAction(BuildContext context, UserBloc userBloc) {
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
    print(fire.FirebaseAuth.instance.currentUser.uid);
    print(await fire.FirebaseAuth.instance.currentUser.getIdToken());
  }

  void _detailDepotAction(BuildContext context, LocationBloc locationBloc,
      TransactionBloc transactionBloc, model.Depot depot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<LocationBloc>.value(value: locationBloc),
            BlocProvider<TransactionBloc>.value(value: transactionBloc),
          ],
          child: DepotPage(depot: depot),
        ),
      ),
    );
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
            padding: Style.mainPadding,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  decoration: Style.containerDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<UserBloc, model.User>(
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
                            onPressed: () =>
                                _historyAction(context, transactionBloc),
                          ),
                          HomeButton(
                            label: 'Akun',
                            icon: Icons.person,
                            onPressed: () => _accountAction(context, userBloc),
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
                  decoration: Style.containerDecoration,
                  child: BlocBuilder<LocationBloc, model.Location>(
                    builder: (context, location) {
                      if (location is model.LocationEnable) {
                        return Column(
                          children: [
                            LongButton(
                              context: context,
                              onPressed: () =>
                                  _mapsAction(context, locationBloc),
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
                                    _detectMapsAction(locationBloc),
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
                BlocConsumer<LocationBloc, model.Location>(
                  listener: (context, location) {
                    if (location is model.LocationEnable ||
                        location is model.LocationSet) {
                      depotBloc.add(model.DepotFetchList(
                        latitude: location.latitude,
                        longitude: location.longitude,
                      ));
                    }
                  },
                  builder: (context, location) {
                    if (location is model.LocationEnable ||
                        location is model.LocationSet) {
                      return BlocBuilder<DepotBloc, model.Depot>(
                        builder: (context, depot) {
                          if (depot is model.DepotListSuccess) {
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: Style.containerDecoration,
                              child: Column(
                                children: [
                                  LongButton(
                                    context: context,
                                    onPressed: () => _allDepotAction(
                                        context,
                                        depotBloc,
                                        locationBloc,
                                        transactionBloc),
                                    icon: Icons.local_drink,
                                    text: 'Semua depot',
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return DepotItem(
                                        depot: depot.depots[index],
                                        onTap: () => _detailDepotAction(
                                            context,
                                            locationBloc,
                                            transactionBloc,
                                            depot.depots[index]),
                                      );
                                    },
                                    itemCount: depot.depots.length > 4
                                        ? 5
                                        : depot.depots.length,
                                  ),
                                ],
                              ),
                            );
                          } else if (depot is model.DepotLoading) {
                            return CircularProgressIndicator();
                          } else if (depot is model.DepotEmpty ||
                              depot is model.DepotError) {
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              width: double.infinity,
                              decoration: Style.containerDecoration,
                              child: Text(
                                depot.toString(),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          return SizedBox.shrink();
                        },
                      );
                    }

                    return SizedBox.shrink();
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
