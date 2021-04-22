import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart' as model;
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  void _mapsAction(BuildContext context, LocationBloc bloc) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapsPage()));
  }

  void _detectMapsAction(LocationBloc locationBloc) {
    locationBloc.add(LocationCurrent());
  }

  void _allDepotAction(BuildContext context, DepotBloc depotBloc,
      LocationBloc locationBloc, TransactionBloc transactionBloc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NearDepotPage()),
    );
  }

  void _historyAction(BuildContext context, TransactionBloc transactionBloc) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryPage()));
  }

  void _accountAction(BuildContext context, UserBloc userBloc) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountPage()));
  }

  void _chatAction(BuildContext context, UserBloc userBloc) async {
    print(fire.FirebaseAuth.instance.currentUser.uid);
    print(await fire.FirebaseAuth.instance.currentUser.getIdToken());
  }

  void _detailDepotAction(BuildContext context, LocationBloc locationBloc,
      TransactionBloc transactionBloc, model.Depot depot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DepotPage(depot: depot)),
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
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, user) {
                          if (user is UserSuccess) {
                            return Text('Hai, ${user.name}');
                          }
                          return Text('Hai, -');
                        },
                      ),
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
                            onPressed: () => _chatAction(context, userBloc),
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
                  child: BlocBuilder<LocationBloc, LocationState>(
                    builder: (context, event) {
                      if (event is LocationEnable) {
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
                              child: Text(event.location.address),
                            ),
                          ],
                        );
                      }

                      if (event is LocationPermissionUnable ||
                          event is LocationServiceUnable) {
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
                              Text(event.toString()),
                            ],
                          ),
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                ),
                SizedBox(height: 30.0),
                BlocConsumer<LocationBloc, LocationState>(
                  listener: (context, event) {
                    if (event is LocationEnable || event is LocationSet) {
                      model.Location location =
                          (event as LocationEnable).location;

                      depotBloc.add(DepotFetchList(location: location));
                    }
                  },
                  builder: (context, location) {
                    if (location is LocationEnable || location is LocationSet) {
                      return BlocBuilder<DepotBloc, DepotState>(
                        builder: (context, event) {
                          if (event is DepotFetchListSuccess) {
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
                                        depot: event.depots[index],
                                        onTap: () => _detailDepotAction(
                                            context,
                                            locationBloc,
                                            transactionBloc,
                                            event.depots[index]),
                                      );
                                    },
                                    itemCount: event.depots.length > 4
                                        ? 5
                                        : event.depots.length,
                                  ),
                                ],
                              ),
                            );
                          } else if (event is DepotLoading) {
                            return CircularProgressIndicator();
                          } else if (event is DepotEmpty ||
                              event is DepotError) {
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              width: double.infinity,
                              decoration: Style.containerDecoration,
                              child: Text(
                                event.toString(),
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
