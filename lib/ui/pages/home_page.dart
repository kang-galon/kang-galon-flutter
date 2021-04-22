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
                  decoration: Style.containerDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserSuccess) {
                              return Text('Hai, ${state.name}');
                            }
                            return Text('Hai, -');
                          },
                        ),
                      ),
                      Divider(
                        thickness: 3.0,
                        height: 20.0,
                        color: Colors.grey.shade400,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Row(
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
                              onPressed: () =>
                                  _accountAction(context, userBloc),
                            ),
                            HomeButton(
                              label: 'Chat',
                              icon: Icons.article,
                              onPressed: () => _chatAction(context, userBloc),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: Style.containerDecoration,
                  child: BlocConsumer<LocationBloc, LocationState>(
                    listener: (context, state) {
                      if (state is LocationError) {
                        showSnackbar(context, state.toString());
                      }
                    },
                    builder: (context, state) {
                      if (state is LocationEnable) {
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
                              child: Text(state.location.address),
                            ),
                          ],
                        );
                      }

                      if (state is LocationPermissionUnable ||
                          state is LocationServiceUnable ||
                          state is LocationError) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
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
                              Text(state.toString()),
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
                      return BlocConsumer<DepotBloc, DepotState>(
                        listener: (context, state) {
                          if (state is DepotError) {
                            showSnackbar(context, state.toString());
                          }
                        },
                        builder: (context, state) {
                          if (state is DepotFetchListSuccess) {
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
                                        depot: state.depots[index],
                                        onTap: () => _detailDepotAction(
                                            context,
                                            locationBloc,
                                            transactionBloc,
                                            state.depots[index]),
                                      );
                                    },
                                    itemCount: state.depots.length > 4
                                        ? 5
                                        : state.depots.length,
                                  ),
                                ],
                              ),
                            );
                          } else if (state is DepotLoading) {
                            return CircularProgressIndicator();
                          } else if (state is DepotEmpty ||
                              state is DepotError) {
                            return Container(
                              padding: EdgeInsets.all(10.0),
                              width: double.infinity,
                              decoration: Style.containerDecoration,
                              child: Text(
                                state.toString(),
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
