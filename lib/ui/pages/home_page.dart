import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart' as model;
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/config/pallette.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocationBloc _locationBloc;
  late DepotBloc _depotBloc;
  late TransactionCurrentBloc _transactionCurrentBloc;
  late RefreshController _refreshController;

  @override
  void initState() {
    // init bloc
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _depotBloc = BlocProvider.of<DepotBloc>(context);
    _transactionCurrentBloc = BlocProvider.of<TransactionCurrentBloc>(context);

    // get current transaction
    _transactionCurrentBloc.add(TransactionFetchCurrent());

    // get current location
    _locationBloc.add(LocationCurrent());

    // init controller
    _refreshController = RefreshController(initialRefresh: false);

    super.initState();
  }

  void _onRefresh() {
    _transactionCurrentBloc.add(TransactionFetchCurrent());

    LocationState state = _locationBloc.state;
    if (state is LocationEnable || state is LocationSet) {
      model.Location location = (state as LocationEnable).location;

      _depotBloc.add(DepotFetchList(location: location));
    }
  }

  void _transactionListener(BuildContext context, TransactionState state) {
    if (state is TransactionFetchCurrentSuccess || state is TransactionEmpty) {
      _refreshController.refreshCompleted();
    }
  }

  void _accountAction() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => AccountPage()));

  void _detectMapsAction() => _locationBloc.add(LocationCurrent());

  void _mapsAction() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MapsPage()));

  void _allDepotAction() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => NearDepotPage()));

  void _detailDepotAction(model.Depot depot) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => DepotPage(depot: depot)));

  void _historyAction() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => HistoryPage()));

  void _phoneAction(Depot depot) async =>
      await launch('tel:${depot.phoneNumber}');

  void _chatAction() async {
    print(await fire.FirebaseAuth.instance.currentUser!.getIdToken());

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatsPage()),
    );
  }

  void _denyTransactionAction() {
    _transactionCurrentBloc.add(TransactionDenyCurrent());

    showSnackbar(context, 'Berhasil dibatalkan');
  }

  void _ratingTransactionAction(double rating) {
    _transactionCurrentBloc
        .add(TransactionRatingCurrent(rating: rating.toInt()));

    showSnackbar(context, 'Berhasil rating');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView(
            padding: Pallette.contentPadding,
            children: [
              _buildHeader(),
              const SizedBox(height: 15.0),
              _buildCurrentTransaction(),
              const SizedBox(height: 15.0),
              _buildCurrentLocation(),
              const SizedBox(height: 15.0),
              _buildNearDepot(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return UserDescription(
          onTap: _accountAction,
          name: (state is UserSuccess) ? state.name : '-',
        );
      },
    );
  }

  Widget _buildCurrentTransaction() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      decoration: Pallette.containerDecoration,
      child: Column(
        children: [
          LongButton(
            context: context,
            onPressed: _historyAction,
            icon: Icons.history,
            text: 'Riwayat transaksi',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: BlocConsumer<TransactionCurrentBloc, TransactionState>(
              listener: _transactionListener,
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return CircularProgressIndicator();
                }

                if (state is TransactionFetchCurrentSuccess) {
                  return TransactionCurrent(
                    transaction: state.transaction,
                    onTapPhone: _phoneAction,
                    onTapChat: _chatAction,
                    onDenyTransaction: _denyTransactionAction,
                    onRatingTransaction: _ratingTransactionAction,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocation() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      decoration: Pallette.containerDecoration,
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationEnable) {
            return Column(
              children: [
                LongButton(
                  context: context,
                  onPressed: _mapsAction,
                  icon: Icons.map,
                  text: 'Ubah lokasi anda',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(state.location.address),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                LongButton(
                  context: context,
                  onPressed: _detectMapsAction,
                  icon: Icons.refresh,
                  text: 'Deteksi lokasi anda',
                ),
                const SizedBox(height: 10.0),
                Text((state is LocationPermissionUnable)
                    ? 'Silahkan izinkan Location'
                    : (state is LocationServiceUnable)
                        ? 'Silahkan aktifkan Location Service'
                        : '-'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearDepot() {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, event) {
        if (event is LocationEnable || event is LocationSet) {
          model.Location location = (event as LocationEnable).location;

          _depotBloc.add(DepotFetchList(location: location));
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
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: Pallette.containerDecoration,
                child: Column(
                  children: [
                    LongButton(
                      context: context,
                      onPressed: _allDepotAction,
                      icon: Icons.local_drink,
                      text: 'Semua depot',
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (state is DepotFetchListSuccess) {
                          Depot depot = state.depots[index];
                          return DepotItem(
                            depot: depot,
                            onTap: () => _detailDepotAction(depot),
                          );
                        }

                        if (state is DepotEmpty) {
                          return Text(
                            'Tidak ada depot di sekitar anda',
                            textAlign: TextAlign.center,
                          );
                        }

                        return DepotItem.loading();
                      },
                      itemCount: (state is DepotFetchListSuccess)
                          ? state.depots.length > 4
                              ? 5
                              : state.depots.length
                          : 1,
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
