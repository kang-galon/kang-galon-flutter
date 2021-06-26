import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/depot_service.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';

class DepotBloc extends Bloc<DepotEvent, DepotState> {
  final SnackbarBloc _snackbarBloc;
  DepotBloc(this._snackbarBloc) : super(DepotUninitialized());

  @override
  Stream<DepotState> mapEventToState(DepotEvent event) async* {
    try {
      if (event is DepotFetchList) {
        yield DepotLoading();

        List<Depot> depots = await DepotService.getDepots(
            event.location.latitude, event.location.longitude);

        if (depots.isEmpty) {
          yield DepotEmpty();
        } else {
          yield DepotFetchListSuccess(depots: depots);
        }
      }
    } catch (e) {
      print('DepotBloc - $e');
      _snackbarBloc.add(SnackbarShow(message: 'Ups.. ada yang salah nih'));

      yield DepotError();
    }
  }
}
