import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class LocationEvent extends Equatable {
  LocationEvent();
}

class LocationCurrent extends LocationEvent {
  @override
  List<Object> get props => [];
}

class LocationSet extends LocationEvent {
  final Location location;

  LocationSet({required this.location});

  @override
  List<Object> get props => [location];
}
