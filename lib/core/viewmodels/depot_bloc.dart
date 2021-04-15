import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/depot.dart';
import 'package:kang_galon/core/services/depot_service.dart';

class DepotBloc extends Bloc<Depot, Depot> {
  final DepotService _depotService = DepotService();

  DepotBloc() : super(DepotUninitialized());

  @override
  Stream<Depot> mapEventToState(Depot depotEvent) async* {
    if (depotEvent is DepotFetchList) {
      yield DepotLoading();

      try {
        DepotListSuccess depotListSuccess = await this
            ._depotService
            .getDepots(depotEvent.latitude, depotEvent.longitude);

        print(depotListSuccess.depots.isEmpty);
        print(depotListSuccess.depots.length);

        if (depotListSuccess.depots.isEmpty) {
          yield DepotEmpty();
        } else {
          yield depotListSuccess;
        }
      } catch (e) {
        print(e.toString());
        yield DepotError();
      }
    }
  }
}
