import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/models/models.dart';
import 'package:kang_galon/core/services/depot_service.dart';

class DepotBloc extends Bloc<DepotEvent, DepotState> {
  final DepotService _depotService = DepotService();

  DepotBloc() : super(DepotUninitialized());

  @override
  Stream<DepotState> mapEventToState(DepotEvent event) async* {
    if (event is DepotFetchList) {
      yield DepotLoading();

      try {
        List<Depot> depots = await this
            ._depotService
            .getDepots(event.location.latitude, event.location.longitude);

        if (depots.isEmpty) {
          yield DepotEmpty();
        } else {
          yield DepotFetchListSuccess(depots: depots);
        }
      } catch (e) {
        yield DepotError();
      }
    }
  }
}
