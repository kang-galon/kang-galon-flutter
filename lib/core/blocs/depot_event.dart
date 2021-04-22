import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class DepotEvent extends Equatable {
  DepotEvent();
}

class DepotFetchList extends DepotEvent {
  final Location location;

  DepotFetchList({this.location});

  @override
  List<Object> get props => [location];
}
