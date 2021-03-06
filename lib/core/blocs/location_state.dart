import 'package:equatable/equatable.dart';
import 'package:kang_galon/core/models/models.dart';

abstract class LocationState extends Equatable {
  LocationState();
}

class LocationUnable extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationServiceUnable extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationPermissionUnable extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationEnable extends LocationState {
  final Location location;

  LocationEnable({required this.location});

  @override
  List<Object> get props => [location];
}

class LocationError extends LocationState {
  @override
  List<Object> get props => [];
}
